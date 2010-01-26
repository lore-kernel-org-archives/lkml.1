Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588Ab0AZGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab0AZGdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563Ab0AZGdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:33:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63750 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0AZGdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tJ7Sqcys209ns+NKtyZ6clJG5/FMmkpmvaH5lc0vpQms4h85OrrWCtnF2Ey9a3Qvyt
         ay9N2b0oetxg4NYBe9eKsCvVq9YlukdC25vrIEs1MsBYYh4GsGFDH31kpOe3TipCt1Jz
         iwwc36xF/O9EuMtfzBvkb7bEKubZ5p5ta4pIY=
Date: Tue, 26 Jan 2010 07:33:43 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
 mce_cpu_specific_poll
Message-ID: <20100126063343.GA18865@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	linux-tip-commits@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aristeu Rozanski <aris@redhat.com>,
	Doug Thompson <norsk5@yahoo.com>, Huang Ying <ying.huang@intel.com>,
	Arjan van de Ven <arjan@infradead.org>
References: <20100121221711.GA8242@basil.fritz.box>
 <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
 <20100123051717.GA26471@elte.hu>
 <20100123075851.GA7098@liondog.tnic>
 <20100123090003.GA20056@elte.hu>
 <20100124100815.GA2895@liondog.tnic>
 <20100125131915.GA7801@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100125131915.GA7801@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 25, 2010 at 02:19:15PM +0100, Andi Kleen wrote:
> > Because this is one thing that has been bugging us for a long time. We
> > don't have a centralized smart utility with lots of small subcommands
> > like perf or git, if you like, which can dump you the whole or parts
> 
> PC configuration is all in dmidecode, CPU/node information in lscpu
> these days (part of utils-linux)
> 
> The dmidecode information could be perhaps presented nicer, but 
> I don't think we need any fundamental new tools.

Uuh, dmidecode doesn't even start to look usable in my book because you
have to rely on BIOS vendors to fill out the information for you. Here
are some assorted excerpts from dmidecode on my machines:

1. Incomplete info:

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: System manufacturer
        Product Name: System Product Name
        Version: System Version
        Serial Number: System Serial Number
        UUID: 201EE116-055E-DD11-8B0E-002215FDB1C6
        Wake-up Type: Power Switch
        SKU Number: To Be Filled By O.E.M.
        Family: To Be Filled By O.E.M.

2. Wrong(!) info:

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
        Socket Designation: L3-Cache
        Configuration: Enabled, Not Socketed, Level 3
        Operational Mode: Varies With Memory Address
        Location: Internal
        Installed Size: 6144 KB
        Maximum Size: 6144 KB
        Supported SRAM Types:
                Pipeline Burst
        Installed SRAM Type: Pipeline Burst
        Speed: Unknown

why?

        Error Correction Type: Single-bit ECC
        System Type: Unified
        Associativity: 4-way Set-associative

how is my L3 4-way set-associative and how do they come up with that???

 [ by the way, it says the same on my old P4 box' L2 so this could mean
   anything besides the actual cache assoc. ]


Here's what the dmidecode manpage says:

"...

BUGS
       More often than not, information contained in the DMI tables is
       inaccurate, incomplete or simply wrong.
...
"

so I guess I'm not the only one :)

In the end, even if the info were correct, it is still not nearly enough
for all the information you might need from a system. So you end up
pulling a dozen of different tools just to get the info you need. So
yes, I really do think we need a tool to get do the job done right and
on any system. And this tool should be distributed with the kernel
sources like perf is, so that you don't have to jump through hoops to
pull the stuff (Esp. if you have to build everything everytime like
Andreas does :)).

> > 1. We need to notify userspace, as you've said earlier, and not scan
> > the syslog all the time. And EDAC, although decoding the correctable
> 
> mcelog never scanned the syslog all the time. This is just
> EDAC misdesign.

Oh yes, EDAC has the edac-utils too which access /sysfs files but even
so, it is suboptimal and we really need a single interface/output
channel/whatever you call a beast like that to reliably transfer human
readable hw error info to userspace and/or network. And this has to be
pushed from kernel space outwards as early as the gravity of the error
suggests, IMO.

> But yes syslog is exactly the wrong interface for these kinds of errors.

Agreed completely.

> > 2. Also another very good point you had is go into maintenance mode by
> > throttling or even suspend all uspace processes and start a restricted
> > maintenance shell after an MCE happens. This should be done based on the
> 
> When you have a unrecoverable MCE this is not safe because you
> can't write anything to disk (and usually the system is unstable
> and will crash soon) because there are uncontained errors somewhere
> in the hardware. The most important thing to do in this situation
> is to *NOT* write anything to disk (and that is the reason
> why the hardware raised the unrecoverable MCE in the first place)
> Having a shell without being able to write to disk doesn't make sense.

Hmm, not necessarily. First of all, not all UC errors are absolutely
valid reasons to panic the machine. Imagine, for example, you encounter
(as unlikely as it might be) a multibit error during L1 data cache
scrubbing which hasn't been consumed yet. Now, technically, no data
corruption has taken place yet so you can easily start the shell on
another core which doesn't have that datum in its cache, decode the
error for the user to see what it was and even allow her/him to poweroff
the machine properly.

Or imagine you have a L2 TLB multimatch - also UC but you can still
invalidate the two entries, maybe kill the processes that have caused
those mappings and start the shell.

So no, not all UC errors have to absolutely cause data corruption and
you can still prepare for a clean exit by warning the user that her/his
data might be compromized and whether (s)he wants to write to disk or
poweroff the machine immediately SysRq-O style.

And even if an UC causes data corruption, panicking the system doesn't
mean that the error has been contained. Nothing can assure you that by
the time do_machine_check() has run the corrupted data hasn't left the
CPU core and landed in another core's cache (maybe even on a different
node) and then on disk through an outstanding write request. That's why
we syncflood the HT links on certain error types since an MCE is not
enough to stop that propagation.

> > 3. All the hw events like correctable ECCs should be thresholded so that
> > all errors exceeding a preset threshold (below that is normal operation
> 
> Agreed. Corrected errors without thresholds are useless (that is one 
> of the main reasons why syslog is a bad idea for them)
> 
> See also my plumbers presentation on the topic:
> 
> http://halobates.de/plumbers-error.pdf
> 
> One key part is that for most interesting reactions to thresholds
> you need user space, kernel space is too limited.
> 
> My current direction was implementing this in mcelog which
> maintains threshold counters and already does a couple of direct (user 
> based) threshold reactions, like offlining cores and pages and reporting
> short user friendly error summaries when thresholds are exceeded.

Yep, sounds good.

> Longer term I hope to move to a more generic (user) error infrastructure
> that handles more kinds of errors. This needs some infrastructure
> work, but not too much.

Yep, I think this is something we should definitely talk about since our
error reporting right now needs a bunch of work to even start becoming
really usable.

> > The current decoding needs more loving too since now it says something
> > like the following:
> 
> Yes, see the slide set above on thoughts how a good error looks like.
> 
> The big problem with EDAC currently is that it neither gives
> the information actually needed (like mainboard labels), but gives
> a lot of irrelevant low level information.

Yes, I'm very well aware of that. I'm currently working on a solution.
It's just an idea now but I might be able to read DIMM configuration
on the SPD ROM on the DIMM along with their labels and position on the
motherboard in order to be able to pinpoint the correct DIMM... Stay
tuned...

> And since it's kernel
> based it cannot do most of the interesting reactions. And it doesn't
> have a usable interface to add user events.
> 
> And yes having all that crap in syslog is completely useless, unless
> you're debugging code.

So basically, IMHO we need:

1. Resilient error reporting that reliably pushes decoded error info to
userspace and/or network. That one might be tricky to do but we'll get
there.

2. Error severity grading and acting upon each type accordingly. This
might need to be vendor-specific.

3. Proper error format suiting all types of errors.

4. Vendor-specific hooks where it is needed for in-kernel handling of
certain errors (L3 cache index disable, for example).

5. Error thresholding, representation, etc all done in userspace (maybe
even on a different machine).

6. Last but not least, and maybe this is wishful thinking, a good tool
to dump hwinfo from the kernel. We do a great job of detecting that info
already - we should do something with it, at least report it...

Let's see what the others think.

Thanks.

-- 
Regards/Gruss,
    Boris.
