Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYELEGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYELEGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYELEF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:05:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38214 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYELEFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:05:55 -0400
Date: Mon, 12 May 2008 05:05:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 3/9] fs/compat.c: fix resource leaks and wrong goto's
Message-ID: <20080512040554.GO13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548033990-git-send-email-xiyou.wangcong@gmail.com> <20080510192111.GC13907@ZenIV.linux.org.uk> <20080510203543.GJ13907@ZenIV.linux.org.uk> <20080512034609.GB2572@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512034609.GB2572@hacking>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:46:09AM +0800, WANG Cong wrote:
> >@@ -1320,17 +1326,15 @@ int do_execve(char * filename,
> > 	retval = search_binary_handler(bprm,regs);
> > 	if (retval >= 0) {
> > 		/* execve success */
> >-		free_arg_pages(bprm);
> > 		security_bprm_free(bprm);
> > 		acct_update_integrals(current);
> >-		kfree(bprm);
> >+		free_bprm(bprm);
> > 		if (displaced)
> > 			put_files_struct(displaced);
> > 		return retval;
> > 	}
> > 
> > out:
> >-	free_arg_pages(bprm);
> 
> 
> Why just drop this? No need to call free_bprm()?

Fixed, pushed to vfs-2.6.git...
