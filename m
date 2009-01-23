Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZAWWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZAWWH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZAWWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:07:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbZAWWHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:07:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: BISECTED: 2.6.29-rc2 regression: hibernation hang on eeepc-701
Date: Fri, 23 Jan 2009 23:06:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com> <200901222305.25824.rjw@sisk.pl> <497991CC.9030200@tuffmail.co.uk>
In-Reply-To: <497991CC.9030200@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901232306.33309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2009, Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > On Thursday 22 January 2009, Alan Jenkins wrote:
> >   
> >> Rafael J. Wysocki wrote:
> >>     
> >>> On Thursday 22 January 2009, Alan Jenkins wrote:
> >>>   
> >>>       
> >>>> Alan Jenkins wrote:
> >>>>     
> >>>>         
> >>>>> Hibernation hangs just after writing the image.  With s2disk I can see
> >>>>> this from the console messages.  The same hang happens with kernel
> >>>>> swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
> >>>>> the image has been written from the HDD led.
> >>>>>
> >>>>> In either case, I can still hard-power-off and resume from hibernation.
> >>>>>
> >>>>> It doesn't hang if I use the shutdown method (either 'echo shutdown |
> >>>>> sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').
> >>>>>   
> >>>>>       
> >>>>>           
> >>>> I've bisected this to commit 571ff7584bb9e05fca0eb79752ae55a46faf3a98. 
> >>>> It doesn't revert cleanly from RC2.
> >>>>
> >>>> I think it's distinct from the other two reported suspend regressions. 
> >>>> I'm not using acpi-cpufreq, and the issue doesn't affect resume.
> >>>>     
> >>>>         
> >>> It looks distinct.
> >>>
> >>> Do you suspend this box to RAM and does it work?
> >>>   
> >>>       
> >> Yes, I do use STR on it occasionally, and it still works in RC2.
> >>
> >>     
> >>> Please retest with the appended patch applied.
> >>>   
> >>>       
> >> That fixes it.
> >>     
> >
> > OK, it won't hurt to apply it.
> >
> > Still, the hardware or the BIOS in your box seems to be broken, or both, so I'd
> > like to debug it a bit more if you don't mind.
> >
> > Can you please test the patch below instead of the previous one?
> >   
> 
> It hangs at the same point as the unpatched RC2.  As before, it doesn't
> hang if I use "shutdown" instead of "platform".
> 
> Going by sysfs, I have 4 PCI devices without a kernel driver.
> 
> 8086:2592   Mobile 915 Express Graphics Controller
> 8086:2792   Mobile 915 Express Graphics Controller (driven by X)
> 8086:2448   82801 Mobile PCI Bridge
> 8086:2641   82801FBM (ICH6M) LPC Interface Bridge

The bridges shouldn't be affected, so I bet on the graphics.

It seems that the BIOS doesn't expect it to be in D3 while entering S4,
although it apparently doesn't mind it to be in D3 while entering S3.

I blame the Asus BIOS writers. ;-)

Thanks,
Rafael
