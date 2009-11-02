Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZKBR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZKBR0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZKBR0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:26:24 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43316 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZKBR0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:26:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FmMl1dbdrQK0elO1LLl7haVoxWGHBrz4gNfGt2aDUW8CtGQznQkOJk2GdP6ZEZuen4
         x3xCDsqLw71vhSztRoE7SK8IGlo6flHY/KJtiYu6fKuMiinGN/ghGJzZagD+p1ahVZ4N
         BV7czEhztbhFMp1BNBIXCCTvc3nh0Gx8BNpm0=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 15:26:07 -0200
Message-ID: <b8bf37780911020926v20ebfcc0nc0b0712875bbb875@mail.gmail.com>
Subject: [PATCH v2 0/7] vsprintf: reduce code size and clean up
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 584d9bfc7c1d41b76a05655b4562b98fcbef6ee4 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 15:10:31 -0200
Subject: [PATCH v2 0/7] vsprintf: reduce code size and clean up
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch reduces code size by 240 bytes on my Core 2 with gcc 4.4.1:
       text    data     bss     dec     hex filename
      15767       0       8   15775    3d9f lib/vsprintf.o-before
      15527       0       8   15535    3caf lib/vsprintf.o-after

and implements some cleanups.

Changelog:
    v2: addressed feedback from Frederic Weisbecker review (thanks!!)
and split into separate patches
    v1: original submission

André Goddard Rosa (7):
  vsprintf: factorize "(null)" string
  vsprintf: pre-calculate final string length
  vsprintf: give it some care to please checkpatch.pl
  vsprintf: use TOLOWER whenever possible
  vsprintf: reduce code size by avoiding extra check
  vsprintf: move local vars to block local vars and remove unneeded
    ones
  vsprintf: factor out skip_space code in a separate function

 lib/vsprintf.c |  306 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 163 insertions(+), 143 deletions(-)
