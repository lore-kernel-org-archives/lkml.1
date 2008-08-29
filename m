Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbYH2RkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbYH2RkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYH2Rj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:39:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34932 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYH2Rj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JnwC/jGtz46neQJcgyf0xThYWn4LK7RimASKQsdicg0tPEe0bIRh6RzdaDAdsdT5Kg
         4bnXlPGuMPB/XwYTirvvgnxqi7XHENfJj6tNqS5Si9ElpOlxeHc84PyR2Ay06uVc8umh
         M0tTr1cutz9DvSBY1TKqDFE4xJUMB6hq9F4Fg=
Message-ID: <b170af450808291039u7d036313x49acdaec079e6213@mail.gmail.com>
Date: Fri, 29 Aug 2008 19:39:57 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808291413260.12571@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <48B701FB.2020905@goop.org>
	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	 <48B76CE0.5010309@goop.org>
	 <20080829102547.655440bf@lxorguk.ukuu.org.uk>
	 <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
	 <Pine.LNX.4.64.0808291120540.8561@blonde.site>
	 <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>
	 <48B7E6EE.9090901@tuffmail.co.uk>
	 <Pine.LNX.4.64.0808291413260.12571@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7THeIdq022812

2008/8/29 Hugh Dickins <hugh@veritas.com>:> Here's my version of Jeremy's patch, that I've now tested on my machines,> as x86_32 and as x86_64.  It addresses none of the points Alan Cox made,> and it stays silent for me, even after suspend+resume, unless I actually> introduce corruption myself.  Omits Jeremy's check in fault.c, but does> a check every minute, so should soon detect RafaÅ‚'s HDMI corruption> without any need to suspend+resume.
Your periodic test works fine:
Corrupted low memory at ffff88000000be9c (be9c phys) = b02a0004 <IRQ>  [<ffffffff8020fc9b>] check_for_bios_corruption+0x93/0x9f [<ffffffff8020fca7>] ? periodic_check_for_corruption+0x0/0x25 [<ffffffff8020fcb0>] periodic_check_for_corruption+0x9/0x25
By the way I confirmed this bug on Sony Vaio FW11M (my one is FW11S).Probably more machines from FW11* are affected.
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
