Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXBVUQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXBVUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXBVUQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:16:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3245 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751828AbXBVUQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:16:58 -0500
Date: Thu, 22 Feb 2007 20:16:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 10/21] Xen-paravirt: add hooks to intercept mm creation and destruction
Message-ID: <20070222201644.GA4938@ucw.cz>
References: <20070216022449.739760547@goop.org> <20070216022531.267584466@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216022531.267584466@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -126,6 +126,12 @@ struct paravirt_ops
>  	void (*io_delay)(void);
>  	void (*const_udelay)(unsigned long loops);
>  
> +	void (fastcall *activate_mm)(struct mm_struct *prev,
> +				     struct mm_struct *next);
> +	void (fastcall *dup_mmap)(struct mm_struct *oldmm, 
> +				  struct mm_struct *mm);
> +	void (fastcall *exit_mmap)(struct mm_struct *mm);
> +

Why the fastcall stuff?  Why is io_delay different from activate_mm in
this regard?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
