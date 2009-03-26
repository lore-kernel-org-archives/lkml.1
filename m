Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZCZL50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZCZL50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZCZL5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:57:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:38451 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZCZL5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wl2L/TLDlWHvkkvQaNtgc1N2DaKktKeVpGPi4Fq3G4pDAlpi1dpOYpyfTx9IelMj4h
         NCpLE3GQ6KOhvyRdX3qRjKMg7PxlV4OuARQqQqXz4MpROfml3A/+wq+/UcnWMkmjHvOi
         p5CQIGvXtF6tes+mY3V6KOlyuI4CwmXs8zF6g=
Subject: Re: fastboot: unpacking initramfs faster
From: Andreas Robinson <andr345@gmail.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.0.999.0903261216550.5843@be1.lrz>
References: <cj9yI-540-17@gated-at.bofh.it>
	 <E1LmEqj-0001SN-6Y@be1.7eggert.dyndns.org>
	 <1238053964.8304.24.camel@andreas-desktop>
	 <alpine.LSU.0.999.0903261216550.5843@be1.lrz>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 12:57:11 +0100
Message-Id: <1238068631.12756.23.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 12:26 +0100, Bodo Eggert wrote:
> On Thu, 26 Mar 2009, Andreas Robinson wrote:
> > On Tue, 2009-03-24 at 23:11 +0100, Bodo Eggert wrote:
[snip]
> > > Why not make a new set? http://7eggert.dyndns.org:8080/l/bgz.tar.gz
> > 
> > Hmm, well if you think there is a chance of it being accepted, then
> > sure! I'll cook something up, but will be looking to use LZO first since
> > it's a bit faster to begin with.
> 
> It's small enough, and now I've updated it to support lzo and put a
> license into the files.

The file permissions are wrong, I'm not allowed to download it.

> Thinking about it: It's now very kernel-specific, other users might like a
> block signature to make it robust against errors - e.g. in the middle of a
> .tar.bgz file. I think I'll change that soon and put 0x55aa in front of
> each block.

I think we'll want an optional checksum of the compressed data.
Suppose bit 32 in the compressed block size field is set, the next field
is the block's Adler32 checksum.
(the adler32 source is in include/linux/zutil.h)

