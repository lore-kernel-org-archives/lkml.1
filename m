Return-Path: <linux-kernel-owner+w=401wt.eu-S1031533AbXEHTVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031533AbXEHTVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031501AbXEHTVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:21:01 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:60844 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031461AbXEHTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:20:59 -0400
Date: Tue, 8 May 2007 21:19:04 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-ID: <20070508191904.GA13368@mailshack.com>
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com> <4640C55B.6030908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4640C55B.6030908@zytor.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Tue, 08 May 2007 21:19:57 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.3.1.53; VDF: 6.38.1.19; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:45:47AM -0700, H. Peter Anvin wrote:
> Alexander van Heukelum wrote:
> > 
> > Oh! A padding hole in a struct! That could be a problem. If the freeze
> > is after decompression, could you test if this makes it work again?
> > 
> 
> The correct fix is to apply __attribute__((packed)) to this structure.

Yeah, I thought about that possibility too, but the struct didn't need
that (in my opinion ugly) annotation before. Oh well, here you go.

Greetings,
	Alexander

---

Commit 89ec4c238e7a3d7e660291f3f1a8181381baad77 introduced a discrepancy
between the struct screen_info which is used by the C code, and the
PARAM_* offsets which are used in the real-mode kernel. As hpa suggests,
adding __attribute__((packed)) to the struct fixes it.

Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>

---

diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index b02308e..4a7c24b 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -44,7 +44,7 @@ struct screen_info {
 	u32 capabilities;       /* 0x36 */
 				/* 0x3a -- 0x3b reserved for future expansion */
 				/* 0x3c -- 0x3f micro stack for relocatable kernels */
-};
+} __attribute__((packed));
 
 extern struct screen_info screen_info;
 
