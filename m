Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXGHV2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXGHV2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbXGHV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:28:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:44850 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbXGHV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TpfJjR0/Ac6WAwGsDfspeJcSHIgEndHXb5bJrX6mM7WiK9W58qd/R9d48/kqoCLaAlqYLkNNKRK3DceTZP1w5S1yRDBXg912V0yrdI+N6PswramcTJm2vuYqztPmS1mbhu1QHWKwVYQEPdxiVqz5uQoYlEGCf50AyqyeIq1QdLc=
Message-ID: <9a8748490707081428p11a9b728m8cec7cc2a122d907@mail.gmail.com>
Date: Sun, 8 Jul 2007 23:28:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: knobi@knobisoft.de
Subject: Re: Understanding I/O behaviour
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490707051322r6e57a8b2xc381ef3c423d3403@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <867098.12378.qm@web32607.mail.mud.yahoo.com>
	 <9a8748490707051322r6e57a8b2xc381ef3c423d3403@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 05/07/07, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> > Hi,
> >
> >  for a customer we are operating a rackful of HP/DL380/G4 boxes that
> > have given us some problems with system responsiveness under [I/O
> > triggered] system load.
> >
> >  The systems in question have the following HW:
> >
> > 2x Intel/EM64T CPUs
> > 8GB memory
> > CCISS Raid controller with 4x72GB SCSI disks as RAID5
> > 2x BCM5704 NIC (using tg3)
> >
> >  The distribution is RHEL4. We have tested several kernels including
> > the original 2.6.9, 2.6.19.2, 2.6.22-rc7 and 2.6.22-rc7+cfs-v18.
> >
> >  One part of the workload is when several processes try to write 5 GB
> > each to the local filesystem (ext2->LVM->CCISS). When this happens, the
> > load goes up to 12 and responsiveness goes down. This means from one
> > moment to the next things like opening a ssh connection to the host in
> > question, or doing "df" take forever (minutes). Especially bad with the
> > vendor kernel, better (but not perfect) with 2.6.19 and 2.6.22-rc7.
> >
> >  The load basically comes from the writing processes and up to 12
> > "pdflush" threads all being in "D" state.
> >
> >  So, what I would like to understand is how we can maximize the
> > responsiveness of the system, while keeping disk throughput at maximum.
> >
>
> I'd suspect you can't get both at 100%.
>
> I'd guess you are probably using a 100Hz no-preempt kernel.  Have you
> tried a 1000Hz + preempt kernel?   Sure, you'll get a bit lower
> overall throughput, but interactive responsiveness should be better -
> if it is, then you could experiment with various combinations of
> CONFIG_PREEMPT, CONFIG_PREEMPT_VOLUNTARY, CONFIG_PREEMPT_NONE and
> CONFIG_HZ_1000, CONFIG_HZ_300, CONFIG_HZ_250, CONFIG_HZ_100 to see
> what gives you the best balance between throughput and interactive
> responsiveness (you could also throw CONFIG_PREEMPT_BKL and/or
> CONFIG_NO_HZ, but I don't think the impact will be as significant as
> with the other options, so to keep things simple I'd leave those out
> at first) .
>
> I'd guess that something like CONFIG_PREEMPT_VOLUNTARY + CONFIG_HZ_300
> would probably be a good compromise for you, but just to see if
> there's any effect at all, start out with CONFIG_PREEMPT +
> CONFIG_HZ_1000.
>

I'm currious, did you ever try playing around with CONFIG_PREEMPT* and
CONFIG_HZ* to see if that had any noticable impact on interactive
performance and stuff like logging into the box via ssh etc...?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
