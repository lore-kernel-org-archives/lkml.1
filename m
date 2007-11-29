Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbXK2UQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbXK2UQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbXK2UQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:16:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778AbXK2UQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:16:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hL5gzIDKIM/YuwGEOyCXBZmldPHTjVN9flMh7DN1z626MrE+WKUY44blW/uBqbcGI
	s485YyH5D/CS5LH77lROQ==
Message-ID: <532480950711291216l181b0bej17db6c42067aa832@mail.gmail.com>
Date: Thu, 29 Nov 2007 12:16:36 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file writes
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Chris Mason" <chris.mason@oracle.com>
In-Reply-To: <396296481.07368@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128192957.511EAB8310@localhost> <396296481.07368@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Due to my faux pas of top posting (see
http://www.zip.com.au/~akpm/linux/patches/stuff/top-posting.txt) I am
resending this email.

On Nov 28, 2007 4:34 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> Could you demonstrate the situation? Or if I guess it right, could it
> be fixed by the following patch? (not a nack: If so, your patch could
> also be considered as a general purpose improvement, instead of a bug
> fix.)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 0fca820..62e62e2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -301,7 +301,7 @@ __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
>                          * Someone redirtied the inode while were writing back
>                          * the pages.
>                          */
> -                       redirty_tail(inode);
> +                       requeue_io(inode);
>                 } else if (atomic_read(&inode->i_count)) {
>                         /*
>                          * The inode is clean, inuse
>

By testing the situation I can confirm that the one line patch above
fixes the problem.

I will continue testing some other cases to see if it cause any other
issues but I don't expect it to.
I will post this change for 2.6.24 and list Feng as author. If that's
ok with Feng.

As for the original patch I will resubmit it for 2.6.25 as a general
purpose improvement.

mrubin
