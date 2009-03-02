Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZCBJxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZCBJxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZCBJxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:53:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbZCBJxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:53:13 -0500
Date: Mon, 2 Mar 2009 10:53:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Message-ID: <20090302095301.GH20897@elte.hu>
References: <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <499DBCDD.90806@knaff.lu> <49AA8AA9.7080200@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AA8AA9.7080200@knaff.lu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alain Knaff <alain@knaff.lu> wrote:

> Alain Knaff wrote:
> > Alain Knaff wrote:
> >> hmmm, but on a second glance, there seems to be indeed an issue. When
> >> compiling it a _second time_, compilation will "succeed" but produce a
> >> bad kernel because the first attempt left an empty
> >> usr/initramfs_data.cpio.bz2 .
> >>
> >> I'll look into it this evening, probably a case of "bad" failure
> >> recovery in the Makefile.
> >>
> > 
> > Took me slightly longer than promised, attached is the patch.
> > 
> > It changes/fixes three things:
> > 1. Fix a bug in decompress.c : only scanned until the first
> > non-configured compressor (with disastrous result if that was gzip)
> > 2. Fix a bug in gen_initramfs_list.sh : in case of failure, it left
> > indeed an empty output file behind, messing up the next make.
> > 3. Make builtin initramfs compression configurable
> > 
> > Regards,
> > 
> > Alain
> > 
> 
> Any comments about this? Ingo, does it solve the issue with 
> randconfig?

I've reactivated tip:x86/setup-lzma in tip:master and started 
testing it with the problem .config, on the problem test-system. 
The bug is most likely fixed, so consider it queued up for 
2.6.30 unless i report some new issue.

Thanks,

	Ingo
