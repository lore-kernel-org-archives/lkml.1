Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYH2G0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYH2G0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbYH2GUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:20:33 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:8645 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbYH2GUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YtdEBbAnSiMiRxe6/OWlLE3bH0LmG6JNsCvJyyndqfhqaUHokpaEP7tnx8tmn1ILA+
         Nd7sLUYRwS6qLQiR2y0tZufbTpeuMIWI9Fb/nxLc1LQr9oFTkdR5/zsfugnTppvWMbni
         /8rSe5Gal4Fgr5jz6SZC/R0pUSjAeIiaFgFqQ=
Message-ID: <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com>
Date: Fri, 29 Aug 2008 08:20:30 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickens" <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48B701FB.2020905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <48B701FB.2020905@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7T6Qkdq015202

2008/8/28 Jeremy Fitzhardinge <jeremy@goop.org>:> Some BIOSes have been observed to corrupt memory in the low 64k.  This> patch does two things:>  - Reserves all memory which does not have to be in that area, to>   prevent it from being used as general memory by the kernel.  Things>   like the SMP trampoline are still in the memory, however.>  - Clears the reserved memory so we can observe changes to it.>  - Adds a function check_for_bios_corruption() which checks and reports on>   memory becoming unexpectedly non-zero.  Currently it's called in the>   x86 fault handler, and the powermanagement debug output.>> RFC: What other places should we check for corruption in?>> [ Alan, RafaÅ‚: could you check you see:>   1: corruption messages>   2: no crashes>  Thanks -J> ]
I was trying my best to crash system with this patch applied and failed :)
Works great.
Just wonder if I should expect any printk fromcheck_for_bios_corruption? I do not see any:
zajec@sony:~> dmesg | grep -i corrscanning 2 areas for BIOS corruption
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
