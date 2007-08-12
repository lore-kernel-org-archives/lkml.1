Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbXHLDeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbXHLDeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbXHLDeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:34:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:47111 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbXHLDeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SqhA03Ard9FlLhDPxcecmv5w56w32Z1EQwoCl4IhAW+6zQQTWq6VFa+G7+D8CPb6GHFCR8KjR02H3z2L98K6OZKWF2f3a5RUNqWOQQ3CrHpsQRGKLSPxos/1jaY9DJVaQUYn2crsk988UM+t56ODIiBCMlSQ1Mg+3f/DHcHJUnI=
Message-ID: <6cf66ee10708112034j65689eacm6a72c6d019e9f62f@mail.gmail.com>
Date: Sat, 11 Aug 2007 17:34:08 -1000
From: "charles gagalac" <charles.gagalac@gmail.com>
To: dean@arctic.org
Subject: [BUG] Kernel panic - not syncing: VFS
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i'm getting the following kernel panic when booting:

Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

a bisect generated the commit below:

3320ad994afb2c44ad34b3b34c3c5cf0da297331 is first bad commit
commit 3320ad994afb2c44ad34b3b34c3c5cf0da297331
Author: dean gaudet
Date:   Fri Aug 10 22:30:59 2007 +0200

    x86: Work around mmio config space quirk on AMD Fam10h

    Some broken devices have been discovered to require %al/%ax/%eax registers
    for MMIO config space accesses.  Modify mmconfig.c to use these registers
    explicitly (rather than modify the global readb/writeb/etc inlines).

    AK: also changed i386 to always use eax
    AK: moved change to extended space probing to different patch
    AK: reworked with inlines according to Linus' requirements.
    AK: improve comments.
