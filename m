Return-Path: <linux-kernel-owner+w=401wt.eu-S935552AbZLQNgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552AbZLQNgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935373AbZLQNgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:36:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:51373 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934483AbZLQNgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YpAOiPTj2cCSTmLTqsRLvLrrv0Vdofhl1xB9FcDPfz9z+swYSoQqeJU2k7W/5piVTx
         mG0TkRc4usAx8R7HWixN3nYbclWMkyfUPtw7z0W7JAz07B1bnniWwRQqcfDii1wjooBD
         uXnFhEj3A5WGGdrm/NqtWsoyJHZ4usGwD2y1w=
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 16:36:06 +0300
Message-ID: <a4423d670912170536m64e71c81v65b11fded21907fb@mail.gmail.com>
Subject: 2.6.32: x86_32: Destination address is too large.
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

IBM x345, 2 * Xeon 2GHz, x86_32, 3Gb of RAM

arch/x86/boot/compressed/misc.c:
asmlinkage void decompress_kernel(


#ifdef CONFIG_X86_64
        if (heap > 0x3fffffffffffUL)
                error("Destination address too large");
#else
        if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
                error("Destination address too large");
#endif


heap is 0x31341b80 here,
CONFIG_PAGE_OFFSET=0xC0000000

gcc version 4.4.0 20090514 (Red Hat 4.4.0-6.314103)

2.6.27 works fine.
