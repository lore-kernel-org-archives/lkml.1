Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbXIQVyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbXIQVyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXIQVxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:53:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:22305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288AbXIQVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hkAMp/eIfrGsbp7pcMpbPMM5WFSms//vHYPhfRyqBOB1PPAA/kAE+p3Dx1wn/JwkxQ3duXANhQF1grJeno7IvGE7WznKL59scQreHVuhUf8SJaBaTSx1RnooG1m7Eq+i5aElX+HRdxFSiO0JrlzULS8tIBkt9wjGE9dtjbnutfA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
Date: Mon, 17 Sep 2007 22:53:42 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709141848.06027.vda.linux@googlemail.com> <s5habrlfw4q.wl%tiwai@suse.de>
In-Reply-To: <s5habrlfw4q.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709172253.42497.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 11:01, Takashi Iwai wrote:
> > There is a lot of data structures in that code,
> > and most of them seems to be read-only.
> > 
> > I added const modifiers to most of such places:
> > 
> >    text    data     bss     dec     hex filename
> >  106315  179564      36  285915   45cdb snd-hda-intel.o
> >  283051    2624      36  285711   45c0f snd-hda-intel_patched.o
> > 
> > Patch is attached.
> > 
> > It moves "static struct hda_codec_preset *hda_preset_tables[]"
> > from hda_patch.h to hda_codec.c, and then adds
> > #include "hda_patch.h"
> > in a few .c files so that definitions of e.g.
> > const struct hda_codec_preset snd_hda_preset_analog[]
> > are checked to match declarations in hda_patch.h
> > 
> > The rest of the patch (bulk of it) adds "const"
> > in many places.
> > 
> > Patch is compile tested. Please apply.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> Sorry for the late reply.
> 
> First, thanks for your patch.  Although I have also a similar patch
> pending on my tree, but it wasn't applied, because I'd like to mark
> these functions/data rather as __devinit*.  And, sadly, init and const
> don't like with each other.

Unless we will go to the pains of implementing __devrodata,
which doesn't sound encouraging.

> So, my plan is to apply __devinit but 
> without const.

Yes, I see. const as it stands is not very useful in kernel anyway
(only a small code reduction sometimes).
ro or rw, the data is still taking space.

Well, maybe someday ld will be sooo clever that it will actually
merge rodata which is identical, but so far it is not implemented.
--
vda
