Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbXEPPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbXEPPTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbXEPPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:19:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbXEPPT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:19:26 -0400
Message-ID: <464B2048.7040103@zytor.com>
Date: Wed, 16 May 2007 08:16:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org>
In-Reply-To: <464ADA5D.8050405@shadowen.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------070804060400030909000204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070804060400030909000204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andy Whitcroft wrote:
> Getting this on both x86 and x86_64 boxes, they are the older boxen so
> likely older compilers:

Please give the gcc version number.

>   CC      arch/x86_64/boot/memory.o
> arch/i386/boot/memory.c: In function `detect_memory':
> arch/i386/boot/memory.c:32: error: can't find a register in class `DREG'
> while reloading `asm'
> 
> Seems to come from git-netsetup, but that tree isn't pulled into your
> git version of -mm so I can't be more specific.

Does the following patch work for you?

	-hpa


--------------070804060400030909000204
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index 8a82aa9..d7b250b 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -30,7 +30,7 @@ static int detect_memory_e820(void)
 		size = sizeof(struct e820entry);
 		id = SMAP;
 		asm("int $0x15; setc %0"
-		    : "=dm" (err), "+b" (next), "+d" (id), "+c" (size),
+		    : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
 		      "=m" (*desc)
 		    : "D" (desc), "a" (0xe820));
 

--------------070804060400030909000204--
