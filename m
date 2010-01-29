Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719Ab0A2WPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0A2WPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159Ab0A2WO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:14:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0A2WO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:14:58 -0500
Date: Fri, 29 Jan 2010 17:14:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: [patch 01/10] smbfs: Convert server->sem to mutex
Message-ID: <20100129221453.GA16158@infradead.org>
References: <20100129203549.526478432@linutronix.de> <20100129203613.406683294@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.406683294@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:38:34PM -0000, Thomas Gleixner wrote:
> The semaphore server->sem is used as mutex. Rename it to server->mutex
> and convert it to a real mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Steve French <sfrench@us.ibm.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

>  static inline int
>  smb_lock_server_interruptible(struct smb_sb_info *server)
>  {
> -	return down_interruptible(&(server->sem));
> +	return mutex_lock_interruptible(&server->mutex);
>  }
>  
>  static inline void
>  smb_lock_server(struct smb_sb_info *server)
>  {
> -	down(&(server->sem));
> +	mutex_lock(&server->mutex);
>  }
>  
>  static inline void
>  smb_unlock_server(struct smb_sb_info *server)
>  {
> -	up(&(server->sem));
> +	mutex_unlock(&server->mutex);
>  }

Eventually someone should also kill this useless wrappers, but let's do
one thing at a time for now.

