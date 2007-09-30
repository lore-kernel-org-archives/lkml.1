Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbXI3QTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbXI3QTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbXI3QTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:19:22 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:26329 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbXI3QTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=klOBJQZe7qShb3iwUrfUw5v1O16IOEiIDeXxbGYIazCwIIrlAglTCLO52ONFe2cEqFHq6v+S45lAfyZSov0NMgrh+KJ8ljgw7dtjtj+rQNpBRXx69FyGknjM6hkOPcbYh4oXH6k73YL0r3+jpHFG+uIx9CKsAW6EaJndtVUw2cM=
Message-ID: <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
Date: Sun, 30 Sep 2007 18:19:19 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46FFB412.20202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>
	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
	 <46FB4CB3.3090004@garzik.org>
	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
	 <46FC1104.8080105@gmail.com>
	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFB412.20202@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello, Torsten.
>
> Torsten Kaiser wrote:
> > On 9/28/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> >> So in case of -rc3-mm1 I'm pretty sure that it works.
> >
> > That's still the case.
>
> Ah... that's weird.  It would be much better if -rc3-mm1 is broken too.  :-P

It would be much better if it would break all the time. Then bisecting
would not be guesswork. :-P

> >> Not completely sure is if 2.6.23-rc7-sglist kernel works. I booted
> >> that 9 times, but from a quick look in /var/log/messages, I might not
> >> have hit the "correct" situation to trigger the error.
> >> That kernel is vanilla 2.6.23-rc7 plus the patch from
> >> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2
> >> ( http://marc.info/?l=linux-ide&m=119055574826083&w=2 )
> >
> > That is no longer the case. Yesterday this kernel did also show the failure.
> > The error looked a little bit different, but happend at the same
> > location during the bootup.
> > Sadly dmesg overflowed and I was not able to capture the first error.
> >
> > [   53.462632] Freeing unused kernel memory: 332k freed
> > ite cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [   77.170903] ata1.00: exception Emask 0x40 SAct 0x1 SErr 0x0 action 0x2
> > [   77.170905] ata1.00: irq_stat 0x00020002, SGT no on qword boundary
> > [   77.170908] ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
> > cdb 0x0 data 4096 out
> > [   77.170909]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask
> > 0x40 (internal error)
>
> Hmm... SGT not on qword boundary?  Please add the following to the end
> of sil24_port_start() and report successful and failed kernel boot log.
>
>         printk("XXX sil24 cb=%p cb_dma=%llx\n",
>                 cb, (unsigned long long)cb_dma);

Added to my current "2.6.23-rc4-mm0.5"
I will report it's output.

> Also, does 'dmesg -s 10000000' give full dmesg?

That boot ended in a minimal initrd environment that normally only
starts the RAID5 and then opens contained encrypted real root.
I was just able to push the output from dmesg through the serial link,
but had no man pages to tell me about -s ...
And that kind of error was until now a one-of-a-kind one. All other
errors where not "internal error" but "timeout".
But one time I had another SGT related error:
Sep 11 19:19:24 treogen [   33.340000] ata1.00: exception Emask 0x20
SAct 0x1 SErr 0x0 action 0x2
Sep 11 19:19:24 treogen [   33.340000] ata1.00: irq_stat 0x00020002,
PCI master abort while fetching SGT
Sep 11 19:19:24 treogen [   33.340000] ata1.00: cmd
61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
Sep 11 19:19:24 treogen [   33.340000]          res
50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)

What I find kind of interessing is, that while I got three different
error codes the cmd part of the output was always the same.

> > Is it possible that the bug is much older, and only some change in
> > rc3-mm->rc4-mm makes it visible that the initialization of the SiI3132
> > is incomplete?
>
> I can't tell but there is a pretty large userbase of sil24/32 and you
> seem to be the only one to report this problem yet.  I think it might be
> coming somewhere else than libata or sata_sil24 itself.  Hmmm... It
> would be really great if you can break -rc3-mm1 too.  Correct behavior
> for something like that for just one -mm version sounds very weird.

It's not just 2.6.23-rc4-mm1. All -mm's after rc4 are broken for me.
Confirmed breakage on -rc4-mm1, -rc6-mm1 and -rc8-mm1. I'm just
narrowing on rc4-mm1 because that was the first version to break.

I'm currently trying to bisect 2.6.23-rc4-mm1. Here is the current status:

[the 2.6.23-rc4-mm1 series-file has 2013 lines]
Up to (incl.) x86_64-convert-to-clockevents.patch (line 747): 2 good boots
Up to (incl.) x86_64-cleanup-struct-irqaction-initializers-patch
(line779): 2 good boots
Up to (incl.) slub-optimize-cacheline-use-for-zeroing.patch (line
1045): 1 failed
Up to (incl.) fix-discrepancy-between-vdso-based... (line1461): 1 good, 1 failed

Next try: up to patch fs-remove-some-aop_truncated_page.patch

That means from the patches added to the rc4 variant of the mm-kernel
the following are remaining:
git-xfs-build-fix.patch
enforce-noreplace-smp-in-alternative_instructions.patch
paravirt-fix-preemptible-lazy-mode-bug.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
fix-the-max-path-calculation-in-radix-treec-update.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
introduce-write_begin-write_end-aops-fix2.patch
implement-simple-fs-aops-fix.patch
ext2-convert-to-new-aops-fix2.patch
ext3-convert-to-new-aops-fix-fix.patch
ext4-convert-to-new-aops-fix-fix.patch
gfs2-convert-to-new-aops-fix.patch
reiserfs-convert-to-new-aops-fix2.patch
hostfs-convert-to-new-aops-fix-fix.patch
ufs-convert-to-new-aops-fix2.patch
sysv-convert-to-new-aops-fix2.patch
minix-convert-to-new-aops-fix2.patch
affs-convert-to-new-aops-fix-fix.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-optimize-cacheline-use-for-zeroing.patch

But due to the unreliable nature of the bug, I can't be to sure about that.

Next version is compiled, now again switching the PC off for an hour...

Torsten
