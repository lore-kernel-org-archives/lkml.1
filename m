Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbXKMR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbXKMR6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXKMR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:57:56 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:57419 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbXKMR5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:57:55 -0500
Date: Tue, 13 Nov 2007 09:55:45 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: William Cohen <wcohen@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, akpm@osdl.org,
       Andi Kleen <andi@firstfloor.org>, gregkh@suse.de,
       perfmon2-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com
Subject: Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113175545.GD4319@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739C42F.8030208@redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 13, 2007 at 10:35:11AM -0500, William Cohen wrote:
> Robert Richter wrote:
> > On 10.11.07 21:32:39, Andi Kleen wrote:
> >> It would be really good to extract a core perfmon and start with
> >> that and then add stuff as it makes sense.
> >>
> >> e.g. core perfmon could be something simple like just support
> >> to context switch state and initialize counters in a basic way 
> >> and perhaps get counter numbers for RDPMC in ring3 on x86[1]
> > 
> > Perhaps a core could provide also as much functionality so that
> > Perfmon can be used with an *unpatched* kernel using loadable modules?
> > One drawback with today's Perfmon is that it can not be used with a
> > vanilla kernel. But maybe such a core is by far too complex for a
> > first merge.
> > 
> > -Robert
> > 
> 
> Hi Robert,
> 
> In the past I suggested that it might be useful to have a version of perfmon2 
> that only set up the perfmon on a global basis. That would allow the patches for 
> context switches to be added as a separate step, splitting up the patch into 
> smaller set of patches.
> 
> Perfmon2 uses a set of system calls to control the performance monitoring 
> hardware. This would make it difficult to use an unpatch kernel unless perfmon 
> changed the mechanism used to control the performance monitoring hardware.
>
Yes, that would be a possibility but as you pointed out there are some problems:

	- perfmon2 uses system calls. So unless you can dynamically patch the
	  syscall table we would have to go back to the ioctl() and driver model.
	  I was under the impression that people did not quite like multiplexing
	  syscalls such as ioctl(). I also do prefer the multi syscall approach.

	- perfmon2 needs to install a PMU interrupt handler. On X86, this is not just
	  an external device interrupts. There needs to be some APIC and interrupt
	  gate setup. There maybe other constraints on other architectures as well.
	  Not sure if all functions/structures necessary for this are available to
	  modules.

	- we could not support per-thread mode with the kernel module approach due to
	  link to the context switch code. I do believe per-thread is a key value-add
	  for performance monitoring.

-- 
-Stephane
