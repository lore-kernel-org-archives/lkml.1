Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYKDWBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYKDWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYKDWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:01:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:32789 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYKDWBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gcEsspmL21X4UpEb9xq/sWxAnAt6ZN1Ealk2ariuMUiTnRU/z0Jhc5zEsAj67VaCNk
         aFgCZD7Smll3yQwiWpMkr3Y3B8Tqqrbn11AzavSqB8Z6AWdP8xOgMygh+uSGOA/0w9Mx
         UjeseMGJtiyWYazoBfl0qEnBx4rkj53CSd0XQ=
Message-ID: <4910C63F.7040309@gmail.com>
Date: Tue, 04 Nov 2008 23:01:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Lior Dotan <liodot@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: Re: [STAGING] slicoss - use kzalloc
References: <491077E3.4010702@gmail.com>
In-Reply-To: <491077E3.4010702@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2008 05:27 PM, Lior Dotan wrote:
> This patch uses kzalloc() where applicable.
> 
> Signed-off-by: Lior Dotan <liodot@gmail.com>

/drivers/staging/slicoss/slicoss.c
=======================================
--- b/drivers/staging/slicoss/slicoss.c	2008-11-04 11:53:12.878116772 +0200
+++ a/drivers/staging/slicoss/slicoss.c	2008-11-04 12:08:40.800644774 +0200
@@ -2673,8 +2673,8 @@
static·int·slic_card_init(struct·sliccar
#if·SLIC_DUMP_ENABLED
» if·(!card->dumpbuffer)·{
-» » card->dumpbuffer·=·kmalloc(DUMP_PAGE_SIZE,·GFP_ATOMIC);
+» » card->dumpbuffer·=·kzalloc(DUMP_PAGE_SIZE,·GFP_ATOMIC);
» » ASSERT(card->dumpbuffer);
» » if·(card->dumpbuffer·==·NULL)
@@ -2683,8 +2683,7 @@
static·int·slic_card_init(struct·sliccar
» ·*··Smear·the·shared·memory·structure·and·then·obtain
» ·*··the·PHYSICAL·address·of·this·structure
» ·*/
-» memset(card->dumpbuffer,·0,·DUMP_PAGE_SIZE);


It's wrong, the function in called multiple times, the memset was called every
time, now it would be called only for the first time.
