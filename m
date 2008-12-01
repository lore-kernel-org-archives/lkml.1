Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYLAVRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYLAVRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYLAVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:17:25 -0500
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:47279 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYLAVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:17:25 -0500
Date: Mon, 1 Dec 2008 22:14:34 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: New IOCTLs
Message-ID: <20081201211434.GD31710@nibiru.local>
Reply-To: weigelt@metux.de
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com> <48D164B9.7020507@redhat.com> <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3baf3d760809172123q5445780dldaaa51d59c0b688a@mail.gmail.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Singaravelan Nallasellan <singaravelann@gmail.com> wrote:

Hi,

> The driver needs to assign an id for each open and create a sysfs
> entry based on that id and expose some properties.
> 
> For example, if the driver assigns an id 2, the sysfs entry will be as below:
> /sys/class/xxx/<drivername>/2/version
> 
> When the driver close is invoked, it will have to remove the entry.
> 
> The issue here is that the application needs:
> 1. To know the id it should use to access properties after the open.
> 2. To have exclusive access to the sysfs entries. No other application
> should and open the entry and use it. There is a chance the the other
> application could open the entries before this application opens it.

Simply add an clone file, reading from it creates new context and 
sends back its ID.

box:/ # cat /sys/class/xxx/foodriver/clone
3

box:/ # cat /sys/class/xxx/foodriver/3/version
1.0

...

To destroy the context:
box:/ # echo "release" > /sys/class/xxx/foodriver/3/ctl


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
