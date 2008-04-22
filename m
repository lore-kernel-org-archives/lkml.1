Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYDVM6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYDVM6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYDVM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:57:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYDVM55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:57:57 -0400
Subject: Re: [PATCH 1/2] klist: implement KLIST_INIT() and DEFINE_KLIST()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       oliver@neukum.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <480DB6A4.20101@gmail.com>
References: <480DB6A4.20101@gmail.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 14:57:29 +0200
Message-Id: <1208869049.7115.254.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 18:57 +0900, Tejun Heo wrote:
> klist is missing static initializers and definition helper.  Add them.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> I can't tell who's in charge of this code, so I'm including last two
> people who made changes and Andrew :-) This will be used by later USB
> mode switch support, so I'm cc'ing USB people too.
> 
> Thanks.
> 
>  include/linux/klist.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/klist.h b/include/linux/klist.h
> index 7407125..c6b697c 100644
> --- a/include/linux/klist.h
> +++ b/include/linux/klist.h
> @@ -25,6 +25,14 @@ struct klist {
>  	void			(*put)(struct klist_node *);
>  };
>  
> +#define KLIST_INIT(_name, _get, _put)					\
> +	{ .k_lock	= __SPIN_LOCK_UNLOCKED(klist.k_lock),		\

May I ask you make that: __SPIN_LOCK_UNLOCKED(_name.k_lock)

Otherwise we'll end up with multiple classes that have the same name.

> +	  .k_list	= LIST_HEAD_INIT(_name.k_list),			\
> +	  .get		= _get,						\
> +	  .put		= _put, }
> +
> +#define DEFINE_KLIST(_name, _get, _put)					\
> +	struct klist _name = KLIST_INIT(_name, _get, _put)
>  
>  extern void klist_init(struct klist * k, void (*get)(struct klist_node *),
>  		       void (*put)(struct klist_node *));

