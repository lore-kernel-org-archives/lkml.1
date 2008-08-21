Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYHUTHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYHUTHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYHUTHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:07:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:16853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYHUTHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cLEjtDP16OsY3UkMRVM3FImN7xWALwPxY7l75K15J2d7RzCgPt9msvLwRZZeEHDuth
         oX1HvMEEZdXSL2dCFhTepBfhv2+BsiB5XdQ8PJr/2YSgQbO6JxMfpVQBgI/WcnPRJ+px
         NJG+uAzK5gE6iCRR0hOQaWIxEZ47X1MhpQ1+I=
Message-ID: <86802c440808211207q28c567e6t995ac3fdac082abc@mail.gmail.com>
Date: Thu, 21 Aug 2008 12:07:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging request"
Cc: "=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?=" <zajec5@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jack Steiner" <steiner@sgi.com>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickens" <hugh@veritas.com>
In-Reply-To: <48ADB041.9040806@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik>
	 <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
	 <48AB5D17.5030600@goop.org>
	 <b170af450808200410v3d7cd076h3e62546b48ddf507@mail.gmail.com>
	 <48AC3FA4.9080603@goop.org>
	 <b170af450808201327q48b5b2e0n319c89b0fc1759b6@mail.gmail.com>
	 <48ADB041.9040806@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7LJ7Ydq005567

On Thu, Aug 21, 2008 at 11:13 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:> Rafa³ Mi³ecki wrote:>> I added full dmesg 5 minutes after adding grepped:>> http://bugzilla.kernel.org/attachment.cgi?id=17331>>>> OK, I think I see the problem (pasted from bugzilla comment):>>>>>>> Some notes as I pick through all the evidence so far:>> - the crash is specifically because there are reserved bits set in the pmd> - the pmd is b02a00043a6001a3 in both cases> - the vaddr is ffff88013a600000 in the first crash, and>               ffff81013a6d1c00 in the second>  corresponding to the same large-page pmd mapping of phys page 0x13a600000> - this maps to e820 entry>  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)> - the corresponding boot-time mapping is>> init_memory_mapping>  0100000000 - 0140000000 page 2M> kernel direct mapping tables up to 140000000 @ b000-11000>                                               ^^^^^^^^^^
this is just estimated. and worst case.
> addr 100000000 reusing pgd 201880 0000000000202063> last_map_addr: 140000000 end: 140000000>> !!! and the memory allocated for this pagetable is:>  #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]>  #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]>                                                     ^^^^^^^^^^^^^^^^^^^^^^^this is correct value used finally.>> IOW, it's mapping using b000-11000, but it has only reserved b000 - c000>> Also, this is right in the middle of the ISA area, which seems risky.> <<<<
YHÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
