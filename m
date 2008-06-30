Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYF3IWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYF3IWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYF3IWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:22:00 -0400
Received: from ozlabs.org ([203.10.76.45]:33705 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYF3IV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:21:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18536.38684.384039.662264@cargo.ozlabs.ibm.com>
Date: Mon, 30 Jun 2008 18:19:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Keep 3 high personality bytes across exec
In-Reply-To: <20080628000813.GA19960@us.ibm.com>
References: <20080628000813.GA19960@us.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric B Munson writes:

> --- a/include/asm-powerpc/elf.h
> +++ b/include/asm-powerpc/elf.h
> @@ -257,7 +257,8 @@ do {								\
>  	else							\
>  		clear_thread_flag(TIF_ABI_PENDING);		\
>  	if (personality(current->personality) != PER_LINUX32)	\
> -		set_personality(PER_LINUX);			\
> +		set_personality(PER_LINUX |			\
> +			(current->personality & PER_INHERIT));	\

Couldn't we use ~PER_MASK here instead of PER_INHERIT?  That would
mean we wouldn't have to modify include/linux/personality.h, and we
wouldn't have to keep updating PER_INHERIT as more flags get added.

(Nice patch description, BTW.  Thanks.)

Paul.
