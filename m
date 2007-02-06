Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXBFKAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXBFKAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXBFKAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:00:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:10171 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXBFKAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=nufYTkLWwptF1nVcTuf+kfKGzdWwmHEd3JXTkDC553+lzXI7MYQYdLK5ORaj3j/fIrEiD0RPmxEVp7r0f8irXHVcSsk11X4LX9w4DPda/OKwFLMakGCCliPXzwr7R9Lh6io0MfbVnGSpdobEvjuVFOXRoAw9EBMJk0FAlTQ4C2c=
Date: Tue, 6 Feb 2007 12:00:25 +0200
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, jeffrey.t.kirsher@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] ixgb: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206100025.GA14903@Ahmed>
References: <20070205165429.GD3896@Ahmed> <20070205165933.GL3896@Ahmed> <20070205201804.GC11055@martell.zuzino.mipt.ru> <45C7941E.2050305@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7941E.2050305@intel.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 12:31:26PM -0800, Auke Kok wrote:
> Alexey Dobriyan wrote:
> >On Mon, Feb 05, 2007 at 06:59:33PM +0200, Ahmed S. Darwish wrote:
> >>A patch to use ARRAY_SIZE macro already defined in kernel.h.
> >
> >Remove it and use ARRAY_SIZE instead.
> >
> >>--- a/drivers/net/ixgb/ixgb_param.c
> >>+++ b/drivers/net/ixgb/ixgb_param.c
> >>@@ -245,7 +245,7 @@ ixgb_validate_option(int *value, struct ixgb_option 
> >>*opt)
> >> 	return -1;
> >> }
> >> 
> >>-#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
> >>+#define LIST_LEN(l) ARRAY_SIZE(l)
> 
> yes, well spotted. Please change line 338 in this file to read:
> 
>      .arg  = { .l = { .nr = ARRAY_SIZE(fc_list),
> 
> instead, so you can remove the LIST_LEN macro completely.
 
Thanks, Here's the new patch.

Use ARRAY_SIZE macro when appropriate.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/net/ixgb/ixgb_param.c b/drivers/net/ixgb/ixgb_param.c
index b27442a..c38ce73 100644
--- a/drivers/net/ixgb/ixgb_param.c
+++ b/drivers/net/ixgb/ixgb_param.c
@@ -245,8 +245,6 @@ ixgb_validate_option(int *value, struct ixgb_option *opt)
 	return -1;
 }
 
-#define LIST_LEN(l) (sizeof(l) / sizeof(l[0]))
-
 /**
  * ixgb_check_options - Range Checking for Command Line Parameters
  * @adapter: board private structure
@@ -335,7 +333,7 @@ ixgb_check_options(struct ixgb_adapter *adapter)
 			.name = "Flow Control",
 			.err  = "reading default settings from EEPROM",
 			.def  = ixgb_fc_tx_pause,
-			.arg  = { .l = { .nr = LIST_LEN(fc_list),
+			.arg  = { .l = { .nr = ARRAY_SIZE(fc_list),
 					 .p = fc_list }}
 		};


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
