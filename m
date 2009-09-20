Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZITTQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZITTQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 15:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZITTQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 15:16:21 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55639 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbZITTQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 15:16:20 -0400
Date: Sun, 20 Sep 2009 21:16:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] coretemp support for Core i5 CPU
Message-ID: <20090920211620.1c18d7fb@hyperion.delvare>
In-Reply-To: <4AB5DE1F.1020004@gmail.com>
References: <4AB5DE1F.1020004@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Sun, 20 Sep 2009 01:47:43 -0600, Robert Hancock wrote:
> Trying to load the coretemp driver for CPU temperature monitoring on a 
> Core i5 750 CPU gives:
> 
> coretemp: Unknown CPU model 1e
> coretemp: Unknown CPU model 1e
> coretemp: Unknown CPU model 1e
> coretemp: Unknown CPU model 1e
> 
> Looks like this model needs to be added to the list in 
> drivers/hwmon/coretemp.c. Though this doesn't really seem like a very 
> good approach as we'll keep having to update this driver whenever a new 
> CPU model gets released. Intel has a CPUID field that indicates if the 
> thermal sensor is supported: "The processor supports a digital thermal 
> sensor if CPUID.06H.EAX[0] = 1." We should likely be using this instead 
> of hard-coded CPU model checks..

Supporting the digital thermal sensor is one thing, but it is totally
insufficient. If you look at the coretemp driver, you'll see we need to
figure out a number of calibration values which are model-dependent. So
we will need to check this part before adding support for new CPU
models anyway.

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
