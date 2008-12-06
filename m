Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYLFUdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYLFUdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYLFUdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:33:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:60609 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYLFUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jKeJYHvzCgmgapkPyX5TkGJttsqFInFrU5TUIjylAa4pOkp9HJRvfJCWwYbQCzIHRf
         Hi/o5Nb3oSDgd24aOzo4CrsV8L/6fFX/IjkySAxe6EVc3G50PoseyNj3EViipZyueiQo
         4JW+BiYy+3GQTs6GLXrgBMCb7Uyui9y7Pt6MM=
Date: Sat, 6 Dec 2008 23:37:40 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: convert to list_for_each()
Message-ID: <20081206203740.GA2264@x200.localdomain>
References: <20081206184905.GA19589@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206184905.GA19589@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 09:49:05PM +0300, Alexander Beregalov wrote:

No, switch to list_for_each_entry() from the very beginning.

> --- a/drivers/staging/me4000/me4000.c
> +++ b/drivers/staging/me4000/me4000.c
> @@ -542,8 +542,7 @@ static void clear_board_info_list(void)
>  	struct me4000_ao_context *ao_context;
>  
>  	/* Clear context lists */
> -	for (board_p = me4000_board_info_list.next;
> -	     board_p != &me4000_board_info_list; board_p = board_p->next) {
> +	list_for_each(board_p, &me4000_board_info_list) {
>  		board_info = list_entry(board_p, struct me4000_info, list);
>  		/* Clear analog output context list */
>  		while (!list_empty(&board_info->ao_context_list)) {
