Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYGCP4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYGCP4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYGCP4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:56:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYGCP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:56:34 -0400
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
	World Order firmware...
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Giacomo A. Catenazzi" <cate@debian.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Selbak, Rolla N" <rolla.n.selbak@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <20080703065630.2aefc930@infradead.org>
References: <4534.1215048758@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	 <32146.1215066947@turing-police.cc.vt.edu>
	 <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	 <486C9AD2.6020604@debian.org>  <20080703065630.2aefc930@infradead.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:54:25 +0100
Message-Id: <1215100465.10393.585.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 06:56 -0700, Arjan van de Ven wrote:
> On Thu, 03 Jul 2008 11:24:34 +0200
> "Giacomo A. Catenazzi" <cate@debian.org> wrote:
> 
> > There are two format of Intel CPU microcode and two methods to load
> > it.
> > - old: the microcodes are in a big file, which include multiple
> >    microcodes (for multiple CPU).  The driver require a char device
> >    and a user space loader ("microcode_ctl")
> > - new: one microcode per file, using the 'request_firmware'
> >    infrastructure. No user space support needed.

Actually there are three:

1. The text format 'microcode.dat', including updates for all CPUs.
2. The binary format output by microcode_ctl, still including all CPUs.
3. The smaller files with just the relevant subset of #2.

The kernel (since 2006) can actually take either #2 or #3. The udev
scripts I just posted will use microcode_ctl to feed it #2, when they
find #1 on the file system.

A small amount of extra work in the userspace tool would let those udev
scripts feed #3 to the kernel, and then the code in the kernel to select
the appropriate update could be removed.

> > Actually Intel provides only the old methods.
> > There was talks with Arjan and Intel about the distribution format
> > for the new methods. But I don't have any new.
> > I think that when the new format is fully specified (directory
> > structure, tar, gzip,...) Intel will distribute the microcodes
> > in the new form.

Doesn't the "new format" (#3) involve hard links too, since there are
some cases where the same microcode update applies to more than one CPU
revision?

> we hope to switch to the new form but there's the small case of
> "installed base" using ancient kernels, and it's kind of not nice to
> have to release 2 sets. At some point we will switch over though.

Do we really need to _ship_ it in a different form? It's not exactly
hard to convert from the text form (#1) to either of the other two --
either on the fly in udev scripts, or at installation time.

-- 
dwmw2

