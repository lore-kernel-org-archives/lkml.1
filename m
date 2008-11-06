Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYKFQHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYKFQHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYKFQHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:07:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYKFQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:06:59 -0500
From: Andreas Schwab <schwab@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian  (was: not enough memory for 522250 flex groups)
References: <200811061600.54264.borntraeger@de.ibm.com>
	<200811061651.49602.borntraeger@de.ibm.com>
X-Yow: There's a lot of BIG MONEY in MISERY if you have an AGENT!!
Date: Thu, 06 Nov 2008 17:06:57 +0100
In-Reply-To: <200811061651.49602.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Thu, 6 Nov 2008 16:51:49 +0100")
Message-ID: <jefxm4alem.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Index: kvm/fs/ext4/super.c
> ===================================================================
> --- kvm.orig/fs/ext4/super.c
> +++ kvm/fs/ext4/super.c
> @@ -1455,7 +1455,7 @@ static int ext4_fill_flex_info(struct su
>  
>  	/* We allocate both existing and potentially added groups */
>  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
> -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
> +			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<

You need to put the "+ 1" after the swap.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
