Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbXGVQIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbXGVQIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXGVQIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:08:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:47164 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXGVQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=S8RCEMjwPVuU671zO/wjTcxAoOsA1emjYxmwitT7UxL2PhuzIz3V0DHp2N06cV1UxaL5FOFrlF6r9obAi8BrTB5Wusml31gW/DGqF3XlgcTAiEy5wAlZYcSPcOXhDXWtk/kwhZqvG6GxWNSqNmYYzhlu2ZcsQBDVwuSwmFMlN0M=
Date: Sun, 22 Jul 2007 20:08:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: sparse breakage (x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu)
Message-ID: <20070722160809.GA5803@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, with new vDSO code sparse fails to check with usual invocation here:

	$ make C=2 CF="-Wno-decl -Wno-shadow -Wno-context -D__CHECK_ENDIAN__"
		...
	  CHECK   arch/x86_64/vdso/vclock_gettime.c
	arch/x86_64/vdso/vclock_gettime.c:51:11: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:47:28: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:48:20: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:49:21: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:38:14: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:39:25: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:80:11: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:75:28: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:76:14: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:77:12: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:78:15: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:79:13: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:87:6: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:102:6: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:111:4: error: expected structure or union
	arch/x86_64/vdso/vclock_gettime.c:111:4: error: expected structure or union
	  CC      arch/x86_64/vdso/vclock_gettime.o
	cc1: error: unrecognized command line option "-Wno-decl"
	cc1: error: unrecognized command line option "-Wno-context"
	make[2]: *** [arch/x86_64/vdso/vclock_gettime.o] Error 1
	make[1]: *** [arch/x86_64/vdso] Error 2
	make: *** [_all] Error 2

