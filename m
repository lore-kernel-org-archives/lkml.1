Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbXKLPXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbXKLPXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXKLPXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:23:22 -0500
Received: from mx1.suse.de ([195.135.220.2]:37235 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXKLPXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:23:22 -0500
Subject: Re: Kernel panic at boot with ondemand governor as
	default	(2.6.24-rc2)
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Eric Piel <Eric.Piel@lifl.fr>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, cpufreq <cpufreq@lists.linux.org.uk>
In-Reply-To: <47385D05.20705@lifl.fr>
References: <4737539F.2070401@lifl.fr>
	 <1194859012.4590.595.camel@queen.suse.de>  <47385D05.20705@lifl.fr>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Mon, 12 Nov 2007 16:23:09 +0100
Message-Id: <1194880989.5474.12.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 15:02 +0100, Eric Piel wrote:
> 11/12/2007 10:16 AM, Thomas Renninger wrote/a écrit:
> > On Sun, 2007-11-11 at 20:10 +0100, Eric Piel wrote:
> >> Hello,
> >>
> >> I've tried kernel 2.6.24-rc2 and I have a problem with the new option 
> >> for setting up the cpufreq ondemand governor as default: a kernel panic 
> >> happens early at boot time. If I boot first with performance governor 
> >> and later change to ondemand, everything is fine (as usual).
> >>
> >> This seems related to the delayed_workqueue. The kernel panic message 
> >> finishes by:
> >> EIP: [<c012aa60>] wq_per_cpu+0x0/0x10 SS:ESP 0068:c191be58
> >> Kernel panic - not syncing: Attempted to kill init!
> >>
> >> A picture of the whole message is available here:
> >> http://pieleric.free.fr/unorder/1162-ondemand-panic.jpg
> >>
> >> My computer is a x86 using speedstep-ich, and you can find the full 
> >> .config leading to the panic attached.
> >>
> >> Does anyone has any idea was it going wrong?
> > 
> > Does it work if you compile speedstep-ich as a module?
> > If you load it, ondemand governor should still be set up automatically.
> > If this works, could it be that the kernel does not like that
> > queue_delayed_work_on is called that early?
> 
> Yes, it works if I compile speedstep-ich as module. I've put the module 
> in initramfs and as soon it is loaded, the ondemand governor is selected 
> and works.
> 
> However, do you think it's ok to prevent cpufreq drivers to be built-in 
> if ondemand governor is selected as default?
> Another way would be to 
> reorganise the initialisation code so that workqueue is initialised 
> before the cpufreq framework is started, do you think it's possible?
Making all this work with low-level drivers built in would be perfect of
course...
If nobody answers the next days, could you open a bug at
bugzilla.kernel.org, so that this does not get lost, pls.
Add myself and Venkatesh to CC...
I try to have a look at it ASAP.
If someone already finds out more, this would be great.

Thanks,

   Thomas

