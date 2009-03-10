Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZCJQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZCJQ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZCJQ0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:26:03 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37884 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCJQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:26:01 -0400
Date: Tue, 10 Mar 2009 11:20:26 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Alexey@smtp1.linux-foundation.org,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090310162026.GA9354@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel> <20090310105702.43eb1402@thinkcentre.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310105702.43eb1402@thinkcentre.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nathan Lynch (ntl@pobox.com):
> Please consider this and a following patch.
> 
> >From a0fb96aa41c4d360559013cfd7f32f07f449c1c4 Mon Sep 17 00:00:00 2001
> From: Nathan Lynch <ntl@pobox.com>
> Date: Mon, 9 Mar 2009 22:23:02 -0500
> Subject: [PATCH] checkpoint: make files_deny_checkpointing print task name and pid
> 
> This lets the developer know *which* task performed an action that
> prevents checkpoint.
> 
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> ---
>  fs/file.c                  |    2 +-
>  fs/open.c                  |    2 +-
>  include/linux/checkpoint.h |   13 +++++++------
>  3 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 0501af6..fcb2803 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -299,7 +299,7 @@ static void __scan_files_for_cr(struct files_struct *files)
>  			continue;
>  		if (cr_file_supported(f))
>  			continue;
> -		files_deny_checkpointing(files);
> +		files_deny_checkpointing(current, files);

Ah but you can't do this, because __scan_files_for_cr is called
from dupfd which is called during copy_files, right?

So you'll need to send the task into __scan_files_for_cr, right?

I do wholeheartedly agree with the idea though.

thanks,
-serge
