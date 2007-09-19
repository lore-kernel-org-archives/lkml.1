Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbXISTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbXISTWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXISTWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:22:16 -0400
Received: from mail.fieldses.org ([66.93.2.214]:32891 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXISTWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:22:13 -0400
Date: Wed, 19 Sep 2007 15:22:12 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Use list_first_entry in locks_wake_up_blocks
Message-ID: <20070919192212.GG5946@fieldses.org>
References: <46F11997.7030005@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F11997.7030005@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 04:44:07PM +0400, Pavel Emelyanov wrote:
> This routine deletes all the elements from the list
> with the "while (!list_empty())" loop, and we already
> have a list_first_entry() macro to help it look nicer :)

OK.

--b.

> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 746dc70..5fa072a 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -534,7 +534,9 @@ static void locks_insert_block(struct fi
>  static void locks_wake_up_blocks(struct file_lock *blocker)
>  {
>  	while (!list_empty(&blocker->fl_block)) {
> -		struct file_lock *waiter = list_entry(blocker->fl_block.next,
> +		struct file_lock *waiter;
> +
> +		waiter = list_first_entry(&blocker->fl_block,
>  				struct file_lock, fl_block);
>  		__locks_delete_block(waiter);
>  		if (waiter->fl_lmops && waiter->fl_lmops->fl_notify)
