Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZKDOjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZKDOjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZKDOju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:39:50 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:38033 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431AbZKDOju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iqBo30lwKHI8Xi3hhB30dtEC+33hR/kyal6VEP+7BNy6quq4fdLqinccO3ngN+gOYZ
         8SwMUQIYWWZzQPXyFOuuGIl2bGVDEmCnrP0uXlPVELd6tZ0RQjrqYby66bf88n6aDXaN
         1yhYLxbE6c0nAYE8wF6dqc9Zt4np5l/ZFX3W4=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:39:35 -0200
Message-ID: <b8bf37780911040639k67575fe6sf0731ed7b3edea62@mail.gmail.com>
Subject: [PATCH v3 0/7] vsprintf: reduce code size and clean up
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>
Date: Tue, 3 Nov 2009 11:21:39 -0200
Subject: [PATCH v3 0/7] vsprintf: reduce code size and clean up
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch reduces code size by 224 bytes on my Core 2 with gcc 4.4.1:

      text    data     bss     dec     hex filename
     15767       0       8   15775    3d9f lib/vsprintf.o-before
     15543       0       8   15551    3cbf lib/vsprintf.o-after

and implements some cleanups.

Changelog:
    v3: improved comments on patch 5/7 and factorize a switch statement on 6/7
as per suggestions from Ingo and Frederic (thanks!)
    v2: addressed feedback from Frederic Weisbecker review (thanks!!)
and split into separate patches
    v1: original submission

André Goddard Rosa (7):
  vsprintf: factorize "(null)" string
  vsprintf: pre-calculate final string length for later use
  vsprintf: give it some care to please checkpatch.pl
  vsprintf: use TOLOWER whenever possible
  vsprintf: reduce code size by avoiding extra check
  vsprintf: move local vars to block local vars and remove unneeded ones
  vsprintf: factor out skip_space code in a separate function

 lib/vsprintf.c |  307 +++++++++++++++++++++++++++++---------------------------
 1 files changed, 159 insertions(+), 148 deletions(-)
