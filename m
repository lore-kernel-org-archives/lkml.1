Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZBZJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZBZJa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZBZJam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:30:42 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:57164 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZBZJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KlhHkRgCC4ykF889aEQbcGDQUMykS19R8mwCVMswo3ALRus3otwjm8Gj0OD1PTxpHU
         GUpfIcq7MoB2cKePK+QmPoErFMHakkUoBTdVU+NYHD5chgTxHbTlNlW09GHLqr8T+xaw
         RfgqQNWzLnAjsO9iLIZWPDHTl/7MgKaPayKT0=
Date: Thu, 26 Feb 2009 12:31:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] introduce pr_cont macro
Message-ID: <20090226093100.GB8111@localhost>
References: <20090225205920.GA22091@localhost> <20090226030315.GB7526@elte.hu> <1235617541.5610.0.camel@brick> <20090226031301.GE7526@elte.hu> <1235618574.5610.1.camel@brick> <20090226032544.GB22223@elte.hu> <49A62899.4080001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A62899.4080001@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Feb 25, 2009 at 09:28:57PM -0800]
> Ingo Molnar wrote:
>>
>> Btw., why do those macros use ##__VA_ARGS__ ? Why not a  
>> straightforward:
>>
>>  #define __pr_cont(args...) \
>>  	printk(KERN_CONT args)
>>
>
> Don't know if anyone cares, but __VA_ARGS__ is C99 whereas args... is a  
> gcc extension, AFAIK.
>
> 	-hpa
>

This one should be fine.

	- Cyrill -
---

Subject: [PATCH] introduce pr_cont macro v2

We cover all log-levels by pr_... macros except
KERN_CONT one. Add it for convenience.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Using 'fmt' here make this macro look similar
to others (same missioned) macros. Which is
good :)

 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/include/linux/kernel.h
===================================================================
--- linux-2.6.git.orig/include/linux/kernel.h
+++ linux-2.6.git/include/linux/kernel.h
@@ -370,6 +370,8 @@ static inline char *pack_hex_byte(char *
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...) \
+        printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
