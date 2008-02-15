Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbYBOD3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbYBOD3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbYBOD26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:28:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:10742 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYBOD25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oAe1zMU6okbYGqS/hNzpru/Ka/hgY/5SwgDo0HbconutHLPy8Hz4dyS3tsVmhcHCQn7P6hjpdvEj6ltxA9eTGEqf9/3+HyOb+RU4P3fypLg8c3xOyIHuY825U9EUbQlFdXReS0DoneedSxKK9j/z64Sf0onhWMGOKmNFsjwDU/E=
Message-ID: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com>
Date: Thu, 14 Feb 2008 19:28:55 -0800
From: "Dan Gora" <dan.gora@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PCI Bursting with PIO
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to optimize a driver for a slave only PCI device and am
having a lot of trouble getting any kind of PCI burst transactions in
either the read or the write direction.  Using bcopy/memcpy or even a
hand-crafted while (len) { *pdst++ = *psrc++} (with pdst and psrc
unsigned long*) I can only get writes to burst and even in that case
only for 2 data phases (8 bytes) and only on 64 bit machines.  The
best that I have managed is to use a hand crafted asm function which
copies the data through mmx registers on i386 machines, but that still
only bursts a maximum of 16 bytes in the write direction and not at
all in the read direction.  The source and destination pointers are
both aligned to 8 byte boundaries, so I don't think that it's an
alignment issue.

Is there any way to get PIO to burst over the PCI bus in the read and
write direction?  My device has 4 BAR registers, but the area where I
am transferring data is marked 'prefetchable' (although the others are
not).  I read here: http://lkml.org/lkml/2004/9/23/393 that this was a
prerequisite, but it is apparently not sufficient.  He also mentioned
that the area had to be marked as write-back, but it's not clear how
you can tell (no /proc/mtrr doesn't tell you) or that it has anything
to do with bursting reads.

Any ideas would be really appreciated,

thanks-
dan
