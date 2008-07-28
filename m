Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbYG1QRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbYG1QRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYG1QRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:17:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:46305 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYG1QRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wGVjZ/kc3svs7v1rN5YED6SW/XRI0/894M+ehNIy8c8auyRpOGfDk7OPKW86gqkyqF
         O466Tw8c/r6zbbbCAafhXCpS70v+57P0BAFYINFDCmYWYVn8sgGgSuzaVd9eisgLJeBp
         p5zEHt8dhgYJm88HAHaN4aB3skCN/+96Apypc=
Message-ID: <488DF119.2000004@gmail.com>
Date: Mon, 28 Jul 2008 18:17:29 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
References: <> <1217260287-13115-1-git-send-email-righi.andrea@gmail.com> <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 28 Jul 2008, Andrea Righi wrote:
>> Move multiple definitions of pmd_free() from different include/asm-* into
>> mm/util.c.
> 
> But this is horrible, because it forces a totally unnecessary function 
> call for that empty function.
> 
> Yeah, the function will be cheap, but the call itself will not be (it's a 
> C language barrier and basically disables optimizations around it, causing 
> thigns like register spill/reload for no good reason).
> 
> 		Linus

yep! clear.

Ok, in this case wouldn't be better at least to define pud_free() as:

static inline pud_free(struct mm_struct *mm, pmd_t *pmd)
{
}

in include/asm-generic/pgtable-nopmd.h, just to avoid the warning
on x86 without PAE?

Thanks for the explanation,
-Andrea
