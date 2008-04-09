Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYDINbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYDINbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYDINbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:31:11 -0400
Received: from saeurebad.de ([85.214.36.134]:44885 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYDINbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:31:10 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pagewalk: don't pte_unmap(NULL) in walk_pte_range()
References: <47FC95AD.1070907@tiscali.nl>
Date: Wed, 09 Apr 2008 15:30:30 +0200
In-Reply-To: <47FC95AD.1070907@tiscali.nl> (Roel Kluin's message of "Wed, 09
	Apr 2008 12:08:45 +0200")
Message-ID: <87zls3qhop.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roel Kluin <12o3l@tiscali.nl> writes:

> This is right isn't it?
> ---
> Don't pte_unmap a NULL pointer, but the previous.

Which NULL pointer?

> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 1cf1417..6615f0b 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -15,7 +15,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  		       break;
>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>  
> -	pte_unmap(pte);
> +	pte_unmap(pte - 1);
>  	return err;
>  }

This does not make any sense to me.

	Hannes
