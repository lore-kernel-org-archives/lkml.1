Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbXCET6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbXCET6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXCET6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:58:34 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10668 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXCET6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:58:33 -0500
Date: Mon, 5 Mar 2007 11:58:29 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Mark Fasheh <mark.fasheh@oracle.com>,
       Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH] ocfs2: fix module_init error handling
Message-ID: <20070305195829.GB20528@ca-server1.us.oracle.com>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>,
	Kurt Hackel <kurt.hackel@oracle.com>
References: <20070304133443.GA8519@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070304133443.GA8519@APFDCB5C>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 10:34:43PM +0900, Akinobu Mita wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> Subject: [PATCH] ocfs2: fix module_init error handling
> 
> Fix error handling in module_init and make module_init() return
> correct error code.

	What are you fixing specifically?  This looks like you are
reorganizing the exit path.  While stylistic differences can exist on
the choice of function exit, claiming there is a "fix" means there is an
actual bug.  Please clarify the bug so we can evaluate your change.

> -leave:
> -	if (status < 0) {
> -		ocfs2_free_mem_caches();
> -		exit_ocfs2_uptodate_cache();
> -		exit_ocfs2_extent_maps();
> -	}
> +	status = register_filesystem(&ocfs2_fs_type);
> +	if (status)
> +		goto err_filesystem;
>  
>  	mlog_exit(status);

	Also, this change suppresses some paths to mlog_exit(), which
impacts people tracing.
	If there is an actual bug you are fixing, please tell us.  We'll
work with you to correct it.

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
