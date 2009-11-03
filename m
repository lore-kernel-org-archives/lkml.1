Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZKCOII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZKCOII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZKCOIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:08:07 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49837 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZKCOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:08:06 -0500
Date: Tue, 3 Nov 2009 23:07:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG option
Message-ID: <20091103140750.GC12841@linux-sh.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk> <8bd0f97a0911030219y685a1dafy2a8e066d7132ac45@mail.gmail.com> <4AF01F18.8040807@tuffmail.co.uk> <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com> <20091103132935.GA12841@linux-sh.org> <8bd0f97a0911030539s582598d6k2f78693bbfa559b0@mail.gmail.com> <20091103134652.GB12841@linux-sh.org> <8bd0f97a0911030558h58725a95m31bb2f73c0772547@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0911030558h58725a95m31bb2f73c0772547@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:58:49AM -0500, Mike Frysinger wrote:
> On Tue, Nov 3, 2009 at 08:46, Paul Mundt wrote:
> > The other thing you seem to have ignored is that pretty much everyone has
> > such a system, it's only crippled platforms like blackfin and h8300 that
> > don't support toolchains without the prefix.
> 
> "cripple" is exactly the right word.  why in the world do you want to
> cripple people that dont need it ?  attempting to support busted
> toolchains by forcing even more symbol prefix crap throughout an arch
> makes no sense at all.  use the -fno-leading-underscore gcc option if
> you want to re-use a non-standard symbol prefixed elf compiler to
> build an arch.

My main consideration is for some SH-2 compilers where only bare metal
targets exist which could theoretically be used for the kernel, too. I've
avoided tying them in precisely because there wasn't a very clean way to
support the prefixed and non-prefixed case dynamically.

On the other hand, in those cases I don't think anyone actually cares
about the ABI, so having gcc not emit the prefix in the first place could
be a valid alternative, I'll give that a try, as that would simplify
things a fair bit.
