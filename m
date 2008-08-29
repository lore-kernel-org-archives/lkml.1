Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYH2T0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYH2T0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYH2TZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:25:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:64316 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYH2TZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fW/6nKhSm+ZZwvebZHNJqntq+YIN+4CmT0svp5LMy/rrF4f022ID8+LeU+RyCfyOmO
         F77vfmY4caFntjkzzZ4oYrQXrse4rdaJadVPYstKC0ZRmg411QS15Qm0V24zRUIq1k88
         V8z/78KqsCT+VcGq43cS0C5WZZFUgBB5AIenc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: Tree for August 27
Date: Fri, 29 Aug 2008 21:23:07 +0200
User-Agent: KMail/1.9.9
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <48B7C361.9070008@kernel.org> <20080829094249.GQ20055@kernel.dk>
In-Reply-To: <20080829094249.GQ20055@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808292123.07246.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 29 August 2008, Jens Axboe wrote:
> On Fri, Aug 29 2008, Tejun Heo wrote:
> > Jens Axboe wrote:
> > >> On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
> > >> introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
> > >> implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
> > >> enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
> > >> in no longer bootable systems (+ help entry for the new option says
> > >> "Say N if you are unsure.").
> > >>
> > >> Tejun/Jens: please consider changing this.
> > > 
> > > I have change the default to 'n' for now.
> > 
> > Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
> > broken?  Did it fail to locate the root partition or were you using
> > static device nodes?
> 
> It works fine for me, fwiw.

It fails to locate the root partition if you are using the default root
device on x86 (the one hard-wired into bzImage, it uses hard-coded 8-bit
major/minor numbers).

Now I see that the issue is easily fixed by passing the root device name
with "root=" (since it will figure out the actual major/minor numbers
later) and that the default root device is said to be deprecated according
to Documentation/x86/boot.txt (OTOH there is no warning at all that it is
deprecated and that you should be using "root=" so I'm not convinced that
I'm the only one who would hit the unfortunate combination).

Actually it seems that CONFIG_DEBUG_BLOCK_EXT_DEVT introduction (which I
think is a nice step forward) is a good oportunity to put the deprecation
of the default root device further, i.e. it may be worth to hook the
default root device check and/or CONFIG_DEBUG_BLOCK_EXT_DEVT one into
mount_block_root().

Thanks,
Bart
