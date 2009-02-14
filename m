Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZBNGRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZBNGRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 01:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZBNGRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 01:17:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZBNGRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 01:17:39 -0500
Message-ID: <499661E9.3070809@zytor.com>
Date: Fri, 13 Feb 2009 22:17:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 pci: Handle mmaping 64bit bars.
References: <m1vdrdveis.fsf@fess.ebiederm.org>
In-Reply-To: <m1vdrdveis.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> While reading through pci_mmap_page_range I realized that if don't
> properly handle 64bit bars in the 32bit kernel.
> 
> Without the added cast the shift will be done in 32bit despite being
> assigned to a 64bit variable and if we are mmaping an address above
> 4G things will do the wrong thing.

Hm... this really should be resource_size_t, no?

> -	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
> +	u64 addr = ((u64)vma->vm_pgoff) << PAGE_SHIFT;

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

