Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXCGGZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXCGGZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbXCGGZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:25:25 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:3106 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932317AbXCGGZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:25:24 -0500
Date: Wed, 7 Mar 2007 07:24:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "J.A. =?ISO-8859-1?Q?Magall=F3n" ?= <jamagallon@ono.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-Id: <20070307072430.c29fd723.khali@linux-fr.org>
In-Reply-To: <20070306164609.2a05a49b@werewolf-wl>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070306164609.2a05a49b@werewolf-wl>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi J.A.,

On Tue, 6 Mar 2007 16:46:09 +0100, J.A. Magallón wrote:
> On Tue, 6 Mar 2007 00:44:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> 
> I have another question about i2c...
> 
> The 'sensors' program gives me a stange message:
> 
> w83627thf-i2c-9191-290
> Can't get adapter name for bus 9191    <<<<<-----------------------------
> VCore:     +1.49 V  (min =  +1.94 V, max =  +1.94 V)       ALARM  
> +12.0V:   +11.86 V  (min = +10.82 V, max = +13.19 V)              
> + 3.3V:    +3.30 V  (min =  +3.14 V, max =  +3.47 V)              
> ...
> 
> And gnome-sensors-applet can't read the sensors. If using libsensors, no

As a side note, this is bad design from gnome-sensors-applet. They
should definitely not plain stop just because they failed to retrieve
the i2c_adapter name, when all the monitored values are otherwise
available.

> value is displayed (I suppose an applicacion bug). And the access to sensors
> directly through i2c-dev gives an error like this:
> 
> Error opening sensor device file:
> /sys/devices/platform/i2c-9191/9191-0290/....
> 
> In fact, the real path is 
> 
> /sys/devices/platform/i2c-adapter:i2c-9191/9191-0290/....
> 
> I supposed it was a kernel change not tracked by userspace, but the strange
> thing is that looking at the code the sensors applet lists the sensors
> reding directories and files in /sys (AFAICS in the code).
> So perhaps there is a little inconsistency, /sys says in some place the
> sensor is at xxxxx, when it really is at yyyyy.
> Or the 'i2c-adapter:' is a bug and should be 'i2c-adapter/'.
> 
> ???

See:
http://bugzilla.kernel.org/show_bug.cgi?id=8115

lm-sensors SVN should work fine:
http://dl.lm-sensors.org/lm-sensors/snapshots/lm-sensors-r4338-20070305.tar.bz2
If not, please report.

We will release it as lm-sensors 2.10.3 soon.

-- 
Jean Delvare
