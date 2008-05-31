Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYFEVXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYFEVXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYFEVXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:23:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYFEVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:23:43 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48485435.7020308@garzik.org>
References: <20080605.foo@pmac.infradead.org>  <48483BA9.1070200@garzik.org>
	 <1212695675.32207.288.camel@pmac.infradead.org>
	 <4848489C.6010903@garzik.org>
	 <1212699190.32207.293.camel@pmac.infradead.org>
	 <48485435.7020308@garzik.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 31 May 2008 22:22:23 +0100
Message-Id: <1212268943.2534.16.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 17:01 -0400, Jeff Garzik wrote:
> If the sha1 sum of what is in the kernel tree differs from what the 
> vendor provided, then it is OBVIOUSLY more difficult to verify that
> you have the original firmware as provided by the vendor.
> 
> Put the binary blobs into the git tree, __without modification or 
> wrapping__.

We don't have them in that form right now. Of the firmware blobs I've
encountered so far -- even the ones which were in a file on their own --
none of them are in binary form; they're _all_ in some ASCII
representation which can be processed with 'diff'. That includes char
arrays, arrays of larger integers which need endian-awareness, 'hex
record' structures, and probably a bunch of other abominations I have
yet to encounter as I work through them.

None of them have just been binary files in the source tree.

I do not believe that taking the existing ascii-source representation
and turning it into binary blobs in the source tree is something which
will be unanimously welcomed. But if you prove me wrong, it's trivial to
switch to doing it that way. For example:
	objcopy -Iihex -Obinary firmware/tr_smctr.bin{.ihex,}
	git-rm firmware/smctr.bin.ihex
	git-add firmware/smctr.bin
	git-commit

I'm going to be making a 'shadow' tree containing the result of running
'make firmware_install', just as I have a tree for exported headers.
That tree _can_ have the raw binaries¹. But I don't think it's
appropriate while the firmware is still in the kernel source tree.

-- 
dwmw2

¹ And I plan to make another tree which pulls from that but also includes
  'distributable' firmware blobs, which the owners wouldn't put into the
  kernel tree because of the GPL requirement that would imply.

