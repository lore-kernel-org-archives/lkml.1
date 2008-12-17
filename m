Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752316AbYLQRSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbYLQRSu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYLQRSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:18:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYLQRSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:18:39 -0500
Subject: Re: [PATCH 9/15] sanitize audit_fd_pair()
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <E1LCohy-0000De-Tc@ZenIV.linux.org.uk>
References: <E1LCohy-0000De-Tc@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 12:18:32 -0500
Message-Id: <1229534312.3384.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 05:12 +0000, Al Viro wrote:
> * no allocations
> * return void
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index ac89cd3..5de0087 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -215,6 +210,7 @@ struct audit_context {
>  			struct mq_attr		attr;
>  		} mq_open;
>  	};
> +	int fds[2];
>  
>  #if AUDIT_DEBUG
>  	int		    put_count;

Waste of space, at least on a 32 bit machine where the size of the ipc
aux data is definitely larger than the sockcall aux data.  But I guess
what you did is a whole lot easier and clearer than to try to hack up
adding it to both sockcall and new pipe_fds and using the right one at
the right time.  I guess if we cared about 64 bits per audited thread we
wouldn't be moving the aux data into the audit_context anyway.

Acked-by: Eric Paris <eparis@redhat.com>

