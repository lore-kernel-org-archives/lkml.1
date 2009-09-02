Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZIBNYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZIBNYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZIBNYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:24:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35119 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZIBNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:24:48 -0400
Date: Wed, 2 Sep 2009 14:24:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       Moiseichuk Leonid <leonid.moiseichuk@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Subject: Re: [PATCH 2/2] ARM: copy_page.S: take into account the size of
	the cache line
Message-ID: <20090902132423.GA12595@n2100.arm.linux.org.uk>
References: <1251907913-16261-1-git-send-email-kirill@shutemov.name> <1251907913-16261-2-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251907913-16261-2-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 07:11:53PM +0300, Kirill A. Shutemov wrote:
>  ENTRY(copy_page)
>  		stmfd	sp!, {r4, lr}			@	2
>  	PLD(	pld	[r1, #0]		)
> -	PLD(	pld	[r1, #32]		)
> +	PLD(	pld	[r1, #L1_CACHE_BYTES]		)
>  		mov	r2, #COPY_COUNT			@	1
>  		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
> -1:	PLD(	pld	[r1, #64]		)
> -	PLD(	pld	[r1, #96]		)
> -2:		stmia	r0!, {r3, r4, ip, lr}		@	4
> -		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
> -		stmia	r0!, {r3, r4, ip, lr}		@	4
> -		ldmia	r1!, {r3, r4, ip, lr}		@	4+1
> +1:	PLD(	pld	[r1, #(2*L1_CACHE_BYTES)])
> +	PLD(	pld	[r1, #(3*L1_CACHE_BYTES)])

I really hate unnecessary parens - please remove them, and put a space
each side of the '*'.

> +2:
> +	.rept	(2 * (L1_CACHE_BYTES) / 16 - 1)

Parens are not required around L1_CACHE_BYTES either.

Other than that, patch is fine.
