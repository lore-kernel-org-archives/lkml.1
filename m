Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYFXNl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYFXNl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbYFXNls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:41:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54166 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969AbYFXNkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:40:31 -0400
Date: Tue, 24 Jun 2008 17:42:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, mingo@elte.hu, torvalds@linux-foundation.org,
       roland@redhat.com, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Message-ID: <20080624134240.GA310@tv-sign.ru>
References: <20080601153042.GA8238@tv-sign.ru> <20080623134037.8566f651.akpm@linux-foundation.org> <20080623134706.f5e1ef32.akpm@linux-foundation.org> <20080623135253.ed7cabf1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623135253.ed7cabf1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Andrew Morton wrote:
>
> On Mon, 23 Jun 2008 13:47:06 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I don't yet know how much additional damage will happen as a result.
> 
> Lots.
> 
> I restored the patches and just dropped the hunk:
> 
>   static int has_mm(struct task_struct *p)
>   {
> -       return (p->mm && !(p->flags & PF_BORROWED_MM));
>   }
>   
>   /**
> --- 86,92 ----
>   
>   static int has_mm(struct task_struct *p)
>   {
> +       return (p->mm && !(p->flags & PF_KTHREAD));
>   }
> 
> due to that function having been turned into:
> 
> static inline bool should_send_signal(struct task_struct *p)
> {
>         return !(p->flags & PF_FREEZER_NOSIG);
> }
>
> Please check the result?

Thanks, this looks OK.

Rafael, can't freezer just use PF_KTHREAD (which btw kills PF_BORROWED_MM)
instead of the new PF_FREEZER_NOSIG flag? They look very similar, please
look at

	"[PATCH 1/3] introduce PF_KTHREAD flag"
	http://marc.info/?l=linux-kernel&m=121233423530812

	"[PATCH 2/3] kill PF_BORROWED_MM in favour of PF_KTHREAD"
	http://marc.info/?l=linux-kernel&m=121233423530820

Oleg.

