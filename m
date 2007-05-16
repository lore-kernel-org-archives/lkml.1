Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXEPXeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXEPXeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbXEPXeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:34:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbXEPXeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:34:17 -0400
Message-ID: <464B9474.2080408@zytor.com>
Date: Wed, 16 May 2007 16:32:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie>
In-Reply-To: <20070516174046.GE10225@skynet.ie>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------080403060707040200020507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080403060707040200020507
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Mel Gorman wrote:
>   LD      arch/i386/boot/setup.elf
> ld:arch/i386/boot/setup.ld:47: syntax error

Does this patch fix it for you?

	-hpa

--------------080403060707040200020507
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/setup.ld b/arch/i386/boot/setup.ld
index e9ca0c2..c9c5530 100644
--- a/arch/i386/boot/setup.ld
+++ b/arch/i386/boot/setup.ld
@@ -44,5 +44,5 @@ SECTIONS
 
 	/DISCARD/ : { *(.note*) }
 
-	ASSERT(_end <= 0x8000, "Setup too big!")
+	. = ASSERT(_end <= 0x8000, "Setup too big!")
 }

--------------080403060707040200020507--
