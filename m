Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbYEATrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbYEATrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbYEATqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:46:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:36390 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbYEATqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gLPF8HHjprfa8k8uAo9XVH8lsfK1fke+TLRQcFvTO4+px4+sYZpuuLyU2yBh4B0hOUa3/BYCYxirKCic8RSOV8+jvQsjuqNquXZdWYsFoXzUoTB3N4xHDZnSo/xZclBVFPwMCcsmh4JeeY1BykrQ/9WJNM42ua4VNDRyw3gPH9s=
Message-ID: <54b90fdf0805011246v64d28c7ao8eb848419890d20a@mail.gmail.com>
Date: Thu, 1 May 2008 15:46:52 -0400
From: Yan <rottled@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Comprehensive list of kernel self-modifications?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been working on verifying kernel integrity and am trying to
differentiate
between vmlinux image on disk and the kernel loaded into memory. I understand
 that the kernel modifies itself (on x86 at least) during at least a few points:


1. It applies alternative instructions with apply_alternatives() from
check_bugs().
    The locations of all alternatives are found between __alt_instructions and
    __alt_instructions__end.
2. It also applies what looks to be relocation. I see the list of
reloc addresses at
    the end of vmlinux image and it appears that relocate_kernel in
relocate_kernel.S
    applies the relocations. I can't tell how it knows where the list
of addresses that
    need relocations is found. Nothing that I found points to that
area, and the on-
    disk data seems to live what gets mapped to as BSS when its running.
3. After manual inspection of all the relocs and alternatives, theres
still about 120
    bytes different. The data looks like groups of 3bytes+address tuples.

Most of this was found via trial and error, so I'm sure there are
other cases of
self-modification. Can anyone point me to a comprehensive list of everywhere
that a kernel can change its own text? Or if anyone knows off the top of their
head, that would be helpful too.

P.S. Please CC to me as I am not subscribed to the list.


Thank you in advance,
Yan
