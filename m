Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYILPQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYILPQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYILPQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:16:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:19032 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYILPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SDA2bMisyvG7p3b0KaGOQgbkNgLZfSY/3dPA1L0Ful7q9hhxSKBfXGUwRYt7fAZeH2
         n4bCEx2IoXi73evHjcSydGtldrXMB/ngrz2qz26UfAAQu5195ZmeBlUYQ8tl1JFJYh7c
         fDAetaO3ecDTS0SJbCQ2xGIzNseQ6MTJ3LTcM=
Message-ID: <8bd0f97a0809120816l30720d4xb4647d902edcf657@mail.gmail.com>
Date: Fri, 12 Sep 2008 11:16:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: arjan@linux.intel.com
Subject: init_post() calling prepare_namespace() causes troubles
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with this commit:

commit db62cd29f9b9142c19c574ca00916f66ff22ed4a
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Sun Jul 20 13:01:28 2008 -0700
fastboot: retry mounting the root fs if we can't find init

we end up with this build failure:
WARNING: init/built-in.o(.text+0x234): Section mismatch in reference
from the function _init_post() to the function
.init.text:_prepare_namespace()
The function _init_post() references
the function __init _prepare_namespace().
This is often because _init_post lacks a __init
annotation or the annotation of _prepare_namespace is wrong.

looking at init_post(), the first thing we do is free_initmem(), so
calling prepare_namespace() after that point looks like it isnt going
to work ... unless there's some magic with initmem_now_dynamic that
i'm not aware of, in which case init_post() needs __init_refok
markings ...
-mike
