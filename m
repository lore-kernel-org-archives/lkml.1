Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbYDDTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbYDDTro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbYDDTrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:47:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52468 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbYDDTrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:47:32 -0400
Subject: Re: [RFC PATCH 2/2] futex: use fast_gup()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080404193817.830004000@chello.nl>
References: <20080404193332.348493000@chello.nl>
	 <20080404193817.830004000@chello.nl>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 21:47:17 +0200
Message-Id: <1207338437.29991.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 21:33 +0200, Peter Zijlstra wrote:

> @@ -217,7 +199,7 @@ static int get_futex_key(u32 __user *uad
>  		return 0;
>  	}
>  
> -	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
> +	err = fast_gup(address, 1, 0, &page);
>  	if (err < 0)
>  		return err;
>  


Failed to include the following hunk...

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -203,6 +203,9 @@ static int get_futex_key(u32 __user *uad
 	if (err < 0)
 		return err;
 
+	if (!page)
+		return -EFAULT;
+
 	key->shared.page = page;
 	key->both.offset |= FUT_OFF_PAGE;
 


