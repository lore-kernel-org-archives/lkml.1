Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYLaCsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYLaCsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYLaCrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:47:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYLaCrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:47:48 -0500
Message-ID: <495ADD46.7080601@zytor.com>
Date: Tue, 30 Dec 2008 18:47:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: The bzip2/lzma patches
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alain,

I finally got the tree with your latest bzip2/LZMA code unburied.  My
apologies for having sat on it for so long (you know why.)

Anyway, I did run into a few things that I'd really like to get fixed.

First of all, there are more than just the x86 and ARM tree which is
using the old API, I count at least four more architectures.  I can't
apply the ARM tree anyway, and we clearly need a saner migration way.

Second, the ugly if...goto hacks in init/initramfs.c could be much
cleaner handled by iterating down a list of function pointers -- except
that gunzip() seems to have a different return value (in init/than the
others?!

Third, you're using the construct if (!foo() < 0 && message == NULL)

... which is wrong on three(!) accounts, one technical (! has higher
precedence than <) and two stylistic (write >= instead of !(.. < ..) and
write !message instead of message == NULL).

I think the solution to all of this is to introduce a new function
instead of gunzip(), and have the old gunzip() be a wrapper using the
old ABI.  That is much cleaner than relying on #ifdef NEW_CODE.

Finally, I know I suggested it, but I don't think the
<linux/decompress/*.h> header file are justified given that they only
contain a single function header.  Might as well put them all in a
single <linux/decompress.h> header.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

