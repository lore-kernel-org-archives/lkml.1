Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZIHGFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZIHGFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZIHGFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:05:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:7491 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbZIHGFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,351,1249282800"; 
   d="scan'208";a="446535032"
Subject: Re: [Bisected] Output to external monitor is broken (Re: Linux
	2.6.31-rc9)
From: ykzhao <yakui.zhao@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: "Ma, Ling" <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain>
	 <20090906142206.GA4449@Pilar.aei.mpg.de>
	 <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 08 Sep 2009 14:05:33 +0800
Message-Id: <1252389933.3609.145.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 02:37 +0800, Linus Torvalds wrote:
> [ Just adding all the right people to the email participants line.
>   Eric, Jesse, Zhao, Ma Ling - should I just revert that commit?
If it is nearly the release window, this commit can be reverted.

Of course I will try to debug this issue.

After comparing the dmesg on the failing/working kernel, it seems that
there is no difference about the display setting. Pipe A is used by VGA
and the mode is 1680x1050(the Clock is 119Mhz). Pipe B is used by LVDS
and the mode is 1280x800(68.8Mhz).

In fact the commit(f8aed700) is to set the pipe_clone bit for the output
device. This is to check whether the one pipe can be shared by several
output devices.
And on the Carlos's laptop there are two pipes and two output device.
There is no issue about sharing pipe.

I test the 2.6.31-rc9 kernel on three laptops and try several external
monitors. In my test there is no issue reported by Carlos.

Hi, Carlos
    Will you please attach the intel_reg_dump on the failing/working
kernel? 
    The intel_reg_dump tool can be found in xf86-video-intel driver.

Thanks.
> 
>   Carlos - can you also do the full dmesg _with_ the corruption? I realize 
>   that your screen is unreadable, but if you can just log in blindly, and
>   do a "dmesg > saved-dmesg-file" and then do a clean reboot? No need for 
>   a serial console or anything fancy - I assume the machine is still 
>   working, just with bad output.
> 
>   It might also be a good idea to boot with "drm.debug=15" to enable much 
>   more debugging output.
> 			- Linus ]
> 
> On Sun, 6 Sep 2009, Carlos R. Mafra wrote:
> >
> > On Sat  5.Sep'09 at 16:54:27 -0700, Linus Torvalds wrote:
> > > Go wild, and please give this a final round of testing.
> > 
> > The output from my Vaio laptop to the external monitor (LG Flatron M228WD) 
> > is broken now. The screen is all messed-up once the boot messages from the
> > kernel appear on it (see the picture at the link below).
> > 
> > I bisected it down to f8aed700c6ec46ddade6570004ce25332283b306 ("drm/i915:
> > Set crtc/clone mask in different output devices"). I doubled checked
> > that reverting this commit from 2.6.31-rc9 fixes the problem.
> > 
> > The picture of the bad output is here:
> > http://www.aei.mpg.de/~crmafra/bad_output.jpg
> > 
> > as well as my config:
> > http://www.aei.mpg.de/~crmafra/config-2.6.31-rc9.txt
> > 
> > and dmesg (with the above commit reverted):
> > http://www.aei.mpg.de/~crmafra/dmesg-2.6.31-rc9+revert.txt
> > 
> > (the vga=0x0364 in the command line does not work since I
> > enabled KMS, so I get a prompt in the beginning from which I 
> > choose vga=0. But the above regression is not affected by this
> > choice because the command line was always the same during 
> > bisection)
> > 
> > If there is anything else I can do, just let me know.
> > 
> > 
> > 
> > 

