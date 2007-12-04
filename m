Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXLDSU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXLDSU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXLDSUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:20:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40332 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLDSUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:20:20 -0500
Subject: Re: [PATCH 1/3] x86_64: define all _PAGE_* in terms of _PAGE_BIT_*
From: Dave Hansen <haveblue@us.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <11967818313780-git-send-email-joerg.roedel@amd.com>
References: <11967818313616-git-send-email-joerg.roedel@amd.com>
	 <11967818313780-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 10:20:15 -0800
Message-Id: <1196792415.6073.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-04 at 16:23 +0100, Joerg Roedel wrote:
> 
> -#define _PAGE_FILE     0x040   /* nonlinear file mapping, saved PTE;
> unset:swap */
> -#define _PAGE_GLOBAL   0x100   /* Global TLB entry */
> +#define _PAGE_PRESENT  (_AC(1, UL)<<_PAGE_BIT_PRESENT)
> +#define _PAGE_RW       (_AC(1, UL)<<_PAGE_BIT_RW)
> +#define _PAGE_USER     (_AC(1, UL)<<_PAGE_BIT_USER)
> +#define _PAGE_PWT      (_AC(1, UL)<<_PAGE_BIT_PWT)
> +#define _PAGE_PCD      (_AC(1, UL)<<_PAGE_BIT_PCD)
> +#define _PAGE_ACCESSED (_AC(1, UL)<<_PAGE_BIT_ACCESSED)
> +#define _PAGE_DIRTY    (_AC(1, UL)<<_PAGE_BIT_DIRTY)
> +/* 2MB page */
> +#define _PAGE_PSE      (_AC(1, UL)<<_PAGE_BIT_PSE)
> +/* nonlinear file mapping, saved PTE; unset:swap */
> +#define _PAGE_FILE     (_AC(1, UL)<<_PAGE_BIT_FILE)
> +/* Global TLB entry */
> +#define _PAGE_GLOBAL   (_AC(1, UL)<<_PAGE_BIT_GLOBAL) 

Since you're defining these as macros anyway now and doing it
repetitively, could you make them a wee bit prettier?

Say something like:

#define _PAGE_MASK(x)	(_AC(1, UL)<<(x))

-- Dave

