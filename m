Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYKHWaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYKHWaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYKHWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:30:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:44498 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYKHWaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=b02nYQoNGojUPSe/2LCjImCNVj5jdExsZJTzmnwwgNfBknus1yhpeAoS4qdi+jOzEQ
         RCx4RE1YIC7JLyncnTFvZbSgdlFAn0xKvMmR6rEC0X2R4NxHY+cx/IXyKdtEQY1Km00s
         rZvPQjKUDUHrG+dp3dhlkPVS6Z1WIM2UxlYl8=
Message-ID: <8bd0f97a0811081430w57fe1548se680f26fd8850ee9@mail.gmail.com>
Date: Sat, 8 Nov 2008 17:30:05 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Mike Travis" <travis@sgi.com>, "Christoph Lameter" <clameter@sgi.com>
Subject: percpu change in vmlinux.lds.h breaks a few arches
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d3794979a8a80c222ce9d016a6dfc4bed36965d0 (Zero based percpu:
infrastructure to rebase the per cpu area to zero) breaks things
because it does not use VMLINUX_SYMBOL() on symbols in
asm-generic/vmlinux.lds.h

for example:
mm/built-in.o: In function `cpu_alloc_init':
(.init.text+0x1496): undefined reference to `__per_cpu_start'
mm/built-in.o: In function `cpu_alloc_init':
(.init.text+0x149c): undefined reference to `__per_cpu_start'
mm/built-in.o: In function `cpu_alloc_init':
(.init.text+0x14a2): undefined reference to `__per_cpu_end'
mm/built-in.o: In function `cpu_alloc_init':
(.init.text+0x14a6): undefined reference to `__per_cpu_end'
make: *** [.tmp_vmlinux1] Error 1
-mike
