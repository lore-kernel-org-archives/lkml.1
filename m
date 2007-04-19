Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXDSWsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXDSWsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbXDSWsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:48:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279AbXDSWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:48:07 -0400
Date: Thu, 19 Apr 2007 15:47:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smbfs: Remove unnecessary allow_signal
Message-Id: <20070419154742.639556d1.akpm@linux-foundation.org>
In-Reply-To: <117696963873-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<117696963873-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:59:03 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/smbfs/smbiod.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smbfs/smbiod.c b/fs/smbfs/smbiod.c
> index 3e61b44..67176af 100644
> --- a/fs/smbfs/smbiod.c
> +++ b/fs/smbfs/smbiod.c
> @@ -298,8 +298,6 @@ out:
>   */
>  static int smbiod(void *unused)
>  {
> -	allow_signal(SIGKILL);
> -
>  	VERBOSE("SMB Kernel thread starting (%d) ...\n", current->pid);
>  

Why is it unnecessary?  afaict we can presently terminate smbiod
with a SIGKILL, and this change will alter (ie: break) that behaviour?
