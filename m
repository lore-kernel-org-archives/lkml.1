Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbYENMox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbYENMox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYENMoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:44:44 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:41203 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754031AbYENMon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:44:43 -0400
Message-ID: <482ADEB8.4030103@LiPPERT-AT.de>
Date: Wed, 14 May 2008 14:44:40 +0200
From: Jens Rottmann <JRottmann@LiPPERT-AT.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, linux-geode@bombadil.infradead.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: lxfb driver regression
References: <20080507210836.1eb61b8f@ephemeral>	<48230694.5010505@LiPPERT-AT.de>	<20080512185148.104fc4c3@ephemeral>	<alpine.LFD.1.10.0805130847150.3019@woody.linux-foundation.org>	<20080513093554.64466981.akpm@linux-foundation.org> <20080513135015.4452fb8f@ephemeral>
In-Reply-To: <20080513135015.4452fb8f@ephemeral>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2008 12:45:05.0316 (UTC) FILETIME=[55849640:01C8B5C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon wrote:
> How's this?  Jordan and Jens, please correct me if I'm off.

It's truly beautiful.

Summing up to avoid complaints.



[PATCH] lxfb: fix regression on OLPC caused by PLL table updates

The following patch caused a regression with OLPC panels:

 commit 3888d4639e78802c4ec1086127124e890461b9e4
    lxfb: extend PLL table to support dotclocks below 25 MHz

    Extends the PLL frequency table of the AMD Geode-LX frame buffer driver to
    make use of the DIV4 bit, thus adding support for dotclocks between 6 and 25
    MHz.  These are needed for small LCDs (e.g. 320x240).  Also inserts some
    intermediate steps between pre-existing frequencies.

The problem was the insertion of intermediate steps into the frequency
table; they would cause the wrong frequency to be matched.  This patch
drops those intermediate frequencies while keeping the sub-25MHz
frequencies.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Jens Rottmann <JRottmann@LiPPERT-AT.de>
---

--- a/drivers/video/geode/lxfb_ops.c~fix-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz
+++ a/drivers/video/geode/lxfb_ops.c
@@ -63,54 +63,32 @@ static const struct {
   { 0x00014284,  19688 },
   { 0x00011104,  20400 },
   { 0x00016363,  23625 },
-  { 0x00015303,  24380 },
   { 0x000031AC,  24923 },
   { 0x0000215D,  25175 },
   { 0x00001087,  27000 },
   { 0x0000216C,  28322 },
   { 0x0000218D,  28560 },
-  { 0x00010041,  29913 },
   { 0x000010C9,  31200 },
   { 0x00003147,  31500 },
-  { 0x000141A1,  32400 },
   { 0x000010A7,  33032 },
-  { 0x00012182,  33375 },
-  { 0x000141B1,  33750 },
   { 0x00002159,  35112 },
   { 0x00004249,  35500 },
   { 0x00000057,  36000 },
-  { 0x000141E1,  37125 },
   { 0x0000219A,  37889 },
   { 0x00002158,  39168 },
   { 0x00000045,  40000 },
-  { 0x000131A1,  40500 },
-  { 0x00010061,  42301 },
   { 0x00000089,  43163 },
-  { 0x00012151,  43875 },
   { 0x000010E7,  44900 },
   { 0x00002136,  45720 },
-  { 0x000152E1,  47250 },
-  { 0x00010071,  48000 },
   { 0x00003207,  49500 },
   { 0x00002187,  50000 },
-  { 0x00014291,  50625 },
-  { 0x00011101,  51188 },
-  { 0x00017481,  54563 },
   { 0x00004286,  56250 },
-  { 0x00014170,  57375 },
-  { 0x00016210,  58500 },
   { 0x000010E5,  60065 },
-  { 0x00013140,  62796 },
   { 0x00004214,  65000 },
-  { 0x00016250,  65250 },
   { 0x00001105,  68179 },
-  { 0x000141C0,  69600 },
-  { 0x00015220,  70160 },
-  { 0x00010050,  72000 },
   { 0x000031E4,  74250 },
   { 0x00003183,  75000 },
   { 0x00004284,  78750 },
-  { 0x00012130,  80052 },
   { 0x00001104,  81600 },
   { 0x00006363,  94500 },
   { 0x00005303,  97520 },

