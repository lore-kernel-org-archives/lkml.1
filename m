Return-Path: <linux-kernel-owner+w=401wt.eu-S1763722AbYENUG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763722AbYENUG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760838AbYENUGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:06:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:45049 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795AbYENUGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=QcJlFHRVYEQnNVlVYkc4UV1RBPt7R7tWjnN3GgFct/WdGkxjCvXvN5kK1a0hROhMxwvGaOtnxkNO1j1rkZPQmA2CyQsrZtBMQyRNO55weI4WVJVH1iaV0LWpCBX86ABym4V5JJC9HBh2H/q/K7Ll9NyXlHXdECiqKVfOfkdiZuU=
Date: Wed, 14 May 2008 22:05:59 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514200558.GA1976@slug>
References: <20080514174955.GA515@elte.hu> <alpine.LFD.1.10.0805141136340.3019@woody.linux-foundation.org> <20080514194122.GA1616@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514194122.GA1616@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
On Wed, May 14, 2008 at 09:41:22PM +0200, Ingo Molnar wrote:
> Subject: remove bkl: reiserfs fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed May 14 16:26:36 CEST 2008
> 
> avoid j_commit_lock deadlock. Since the down() can block it is
> safe to drop the BKL here.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  fs/reiserfs/journal.c |    2 ++
>  fs/super.c            |    2 ++
>  2 files changed, 4 insertions(+)
> 
> Index: linux/fs/reiserfs/journal.c
> ===================================================================
> --- linux.orig/fs/reiserfs/journal.c
> +++ linux/fs/reiserfs/journal.c
> @@ -1044,8 +1044,10 @@ static int flush_commit_list(struct supe
>  		}
>  	}
>  
> +//	unlock_kernel();
 ^^^^
>  	/* make sure nobody is trying to flush this one at the same time */
>  	down(&jl->j_commit_lock);
> +//	lock_kernel();
 ^^^^
>  	if (!journal_list_still_alive(s, trans_id)) {
>  		up(&jl->j_commit_lock);
>  		goto put_jl;
Must be a typo?

Regards,
Frederik
