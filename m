Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYFEWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYFEWU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFEWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:20:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYFEWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:20:16 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4848648D.8010501@garzik.org>
References: <20080605.foo@pmac.infradead.org>  <4848648D.8010501@garzik.org>
Content-Type: text/plain
Date: Sat, 31 May 2008 23:18:57 +0100
Message-Id: <1212272337.2534.27.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 18:11 -0400, Jeff Garzik wrote:
> Here is my "ideal firmware world":
> 
> * do NOT remove ability to compile firmware into the kernel

I have no intention of removing that.


>  (or into a module)

That I don't care about. If you can load modules, you can handle
request_firmware().

> * firmware should be field-replaceable, even if one was compiled in

That would be a useful thing; currently the built-in firmwares cannot be
overridden but it wouldn't be hard to implement. Suggest it in 'diff -u'
form and it might just happen.

> * the preferred form of firmware is one or more binary blobs, stored in 
> a regular [filesystem|git] binary file.

I don't think we have consensus on that, but as I said: post patches and
let's see if they get merged.

> * the preferred form is NOT ascii C source, or any other format other 
> than the native format that the hardware wants.  Remember, the vendor 
> only provided an ASCII-ized firmware because our system required it that 
> way, not because that's the preferred form.

And binary isn't the preferred form either. We can cope with binary, but
it's not appropriate in the kernel source tree, imho.

When I make the shadow tree which contains the results of 'make
firmware_install', that'll have the binaries.

> * in-tree firmwares should be stored in one or more binary files in the 
> tree, not in C source code or .ihex files.
> 
> * when firmware is stored as binary blob, it is easier for
> 	(1) vendor to replace,
> 	(2) developer/user to compare/verify using sha1,
> 	(3) does not require a C compiler or binutils to unpack

All these are true, but you're still missing the point that as I have it
it's already a _lot_ easier to process than when it was arrays of __be32
in some header file. I don't want to change to binary blobs as part of
what I'm doing this week. That's a _separate_ issue, and I'm not even
sure it's a goal I agree with.


> Thus, if you are going to be touching the in-tree firmwares at all, it 
> doesn't make sense to convert from C source to any format other than 
> native binary.

I disagree. But feel free to post patches which get applied and prove me
wrong. I'm not going to object if you want to go convert a few more
drivers.

-- 
dwmw2

