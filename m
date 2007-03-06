Return-Path: <linux-kernel-owner+w=401wt.eu-S965172AbXCFPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbXCFPqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965180AbXCFPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:46:21 -0500
Received: from smtp.ono.com ([62.42.230.12]:28986 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965172AbXCFPqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:46:20 -0500
Date: Tue, 6 Mar 2007 16:46:09 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-ID: <20070306164609.2a05a49b@werewolf-wl>
In-Reply-To: <20070306004408.d3f6434d.akpm@linux-foundation.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.0cvs15 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 00:44:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> 

I have another question about i2c...

The 'sensors' program gives me a stange message:

w83627thf-i2c-9191-290
Can't get adapter name for bus 9191    <<<<<-----------------------------
VCore:     +1.49 V  (min =  +1.94 V, max =  +1.94 V)       ALARM  
+12.0V:   +11.86 V  (min = +10.82 V, max = +13.19 V)              
+ 3.3V:    +3.30 V  (min =  +3.14 V, max =  +3.47 V)              
...

And gnome-sensors-applet can't read the sensors. If using libsensors, no
value is displayed (I suppose an applicacion bug). And the access to sensors
directly through i2c-dev gives an error like this:

Error opening sensor device file:
/sys/devices/platform/i2c-9191/9191-0290/....

In fact, the real path is 

/sys/devices/platform/i2c-adapter:i2c-9191/9191-0290/....

I supposed it was a kernel change not tracked by userspace, but the strange
thing is that looking at the code the sensors applet lists the sensors
reding directories and files in /sys (AFAICS in the code).
So perhaps there is a little inconsistency, /sys says in some place the
sensor is at xxxxx, when it really is at yyyyy.
Or the 'i2c-adapter:' is a bug and should be 'i2c-adapter/'.

???

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam02 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
