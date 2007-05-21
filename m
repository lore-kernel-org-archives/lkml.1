Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbXEUIlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbXEUIlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXEUIlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:41:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:1297 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbXEUIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:41:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lp3b2vwaQc4Xu9CfAhRtjgUUp7hCgngjs3KLOvVNQOyolgNgMj49WCE25SblvEFcOmtmy4ld6psI+prSOFQhHGOKsv3TzllM5xFRU4pHd2/un8q8kEAEoovn3AdgTyQr847+MWCulDss0egr7QZpa7G8CTj6cd45MhCuUrg/WzE=
Message-ID: <a8e1da0705210141m4d9f0ccevde3060fefcc55537@mail.gmail.com>
Date: Mon, 21 May 2007 08:41:43 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.22-rc1-mm1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <465138CC.3060605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>
	 <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>
	 <464DDA40.6010101@zytor.com>
	 <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>
	 <465124EA.1020801@zytor.com>
	 <a8e1da0705202200u5976d14do7ec1469941bb2967@mail.gmail.com>
	 <46512821.9010905@zytor.com>
	 <a8e1da0705202239r31d03a5dyc2f0ce6a795e0124@mail.gmail.com>
	 <465138CC.3060605@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kernel booting and stopped in edd.c:read_sector.

I add debug messages around the two inline assemblly sentence, recompile kernel,
now strange thing happend, the kernel booting directly, but the printf
messages can't be seen because it's too rapid.

can we use printk in boot code?

the change of edd.c:
--- edd.c.bak   2007-05-21 14:38:34.000000000 +0000
+++ edd.c       2007-05-21 15:58:02.000000000 +0000
@@ -47,9 +47,11 @@ static int read_sector(u8 devno, u64 lba
        ax = 0x4200;            /* Extended Read */
        si = (size_t)&dapa;
        dx = devno;
+       printf("before first inline\n");
        asm("pushfl; stc; int $0x13; setc %%al; popfl"
            : "+a" (ax), "+S" (si), "+d" (devno)
            : : "ebx", "ecx", "edi");
+       printf("after first inline\n");

        if (!(u8)ax)
                return 0;       /* OK */
@@ -58,9 +60,11 @@ static int read_sector(u8 devno, u64 lba
        cx = 0x0001;            /* Sector 0-0-1 */
        dx = devno;
        bx = (size_t)buf;
+       printf("before second inline\n");
        asm("pushfl; stc; int $0x13; setc %%al; popfl"
            : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
            : : "esi", "edi");
+       printf("after second inline\n");

        return -(u8)ax;         /* 0 or -1 */
 }



Regards
dave
