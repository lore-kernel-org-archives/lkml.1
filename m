Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXFRAa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXFRAa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbXFRAaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:30:52 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:38512 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbXFRAav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:30:51 -0400
Date: Mon, 18 Jun 2007 09:29:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: asm-sh64/module.h defines 32 bit ELF types
Message-ID: <20070618002921.GA30509@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4672F240.7060106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4672F240.7060106@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 01:10:40PM -0700, Jeremy Fitzhardinge wrote:
> I'm doing a little cleanup of ELF stuff around the tree, and I noticed
> that asm-sh64/module.h defines 32 bit versions of the ELF types rather
> than 64.  Is this right?
> 
Yes, that's correct. sh64 supports both a 64-bit and a 32-bit ABI, but in
practice, only the 32-bit is used (both for kernel and user space). While
registers and loads/stores are 64-bits, the pointer size is still 32 when
using the 32-bit ABI. This was the reason for things like ARCH_SLAB_MINALIGN.
