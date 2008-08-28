Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYH1D35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYH1D35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYH1D3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:29:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:4640 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYH1D3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZjgOgmTgPtMPk+b+myctrJTjRWzIfN5JBTqTIepYZJvDoCstaxfuO5eg4r4PlsZKQk
         VeNaLVERARFvyQYaCB8Ku8cI+t4mKxKxxxrST4z5rX3IDnV7NpYgtUO4mZ6o4GBdcos9
         Hv5QxFZaMcjqdg/4u7Kbk896F21KVHMvXdGg8=
Date: Thu, 28 Aug 2008 07:31:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: + rcu-fix-sparse-shadowed-variable-warning.patch added to -mm
	tree
Message-ID: <20080828033123.GA19218@x200.localdomain>
References: <200808280322.m7S3MOUg004835@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808280322.m7S3MOUg004835@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/kernel/rcuclassic.c~rcu-fix-sparse-shadowed-variable-warning
> +++ a/kernel/rcuclassic.c
> @@ -561,15 +561,15 @@ static void __rcu_process_callbacks(stru
>  		local_irq_restore(flags);
>  
>  		if (rcu_batch_after(rdp->batch, rcp->pending)) {
> -			unsigned long flags;
> +			unsigned long flags2;
>  
>  			/* and start it/schedule start if it's a new batch */
> -			spin_lock_irqsave(&rcp->lock, flags);
> +			spin_lock_irqsave(&rcp->lock, flags2);
>  			if (rcu_batch_after(rdp->batch, rcp->pending)) {
>  				rcp->pending = rdp->batch;
>  				rcu_start_batch(rcp);
>  			}
> -			spin_unlock_irqrestore(&rcp->lock, flags);
> +			spin_unlock_irqrestore(&rcp->lock, flags2);
>  		}
>  	}

Bzzzrt... just remove second variable.

