Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYH2Ly4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYH2Ly4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYH2Lys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:54:48 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:6292 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbYH2Lyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E5W8AC6JI2rYlNod+LarQq649bnvX0ft/A0Pa4ssL8AxxW+hZKYtkUg4/CDfDe+1zN
         5FjPyh43UiUqjEin22i1lZY3djNgmSCmZ0ryxhvkfhYoAOg971xOy84+d0kdrKQWI8Od
         mLxI+t/ePUi7tFrWgqgsrt8XVI/4JFPkni8ys=
Message-ID: <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>
Date: Fri, 29 Aug 2008 13:54:46 +0200
From: "=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=" <zajec5@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808291120540.8561@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <48B701FB.2020905@goop.org>
	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	 <48B76CE0.5010309@goop.org>
	 <20080829102547.655440bf@lxorguk.ukuu.org.uk>
	 <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
	 <Pine.LNX.4.64.0808291120540.8561@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7TBt6dq019001

2008/8/29 Hugh Dickins <hugh@veritas.com>:>> On Fri, 29 Aug 2008, RafaÅ‚ MiÅ‚ecki wrote:>>>> Out of current discussion I tried using s2ram on patched kernel (I did>> not try s2ram earlier, my problem was (un)plugging HDMI - some ACPI>> code probably).>>>> Corruption output is quite huge, I attached it to bug report:>> http://bugzilla.kernel.org/show_bug.cgi?id=11237>> http://bugzilla.kernel.org/attachment.cgi?id=17526>> Not quite the output we were expecting!  I've not got around to trying> it yet, so beware, but I think Jeremy's patch needs the following on top.> Or you may prefer to wait until one of us reports that it is now working> as intended.>> --- a/arch/x86/kernel/setup.c   2008-08-29 11:17:16.000000000 +0100> +++ b/arch/x86/kernel/setup.c   2008-08-29 11:19:24.000000000 +0100> @@ -636,11 +636,12 @@ void check_for_bios_corruption(void)>                unsigned long *addr = __va(scan_areas[i].addr);>                unsigned long size = scan_areas[i].size;>> -               for(; size; addr++, size--) {> +               for(; size; addr++, size -= sizeof(unsigned long)) {>                        if (!*addr)>                                continue;>                        printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",>                               addr, __pa(addr), *addr);> +                       *addr = 0;>                        corruption = 1;>                }>        }
I tried your patch anyway (after applying Jeremy's patch of course)and it doesn't seem to work. The only output is:scanning 2 areas for BIOS corruptionafter using s2ram. I do not get anyCorrupted low memory at*
-- RafaÅ‚ MiÅ‚eckiÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
