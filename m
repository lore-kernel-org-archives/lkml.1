Return-Path: <linux-kernel-owner+w=401wt.eu-S1764868AbYHEUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764868AbYHEUaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764179AbYHEUaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:30:01 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12997 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761975AbYHEU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:29:59 -0400
Date: Tue, 5 Aug 2008 13:29:48 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/cluster/netdebug.c: fix warning
Message-ID: <20080805202948.GL22600@mail.oracle.com>
Mail-Followup-To: Alexander Beregalov <a.beregalov@gmail.com>,
	mfasheh@suse.com, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <20080805201036.GC17320@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805201036.GC17320@orion>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:10:36AM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> ocfs2/cluster/netdebug.c: fix warning
> 
> fs/ocfs2/cluster/netdebug.c:154: warning: format '%lu' expects
> 	type 'long unsigned int', but argument 17 has type 'suseconds_t'
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  fs/ocfs2/cluster/netdebug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
> index d8bfa0e..cdc0ed2 100644
> --- a/fs/ocfs2/cluster/netdebug.c
> +++ b/fs/ocfs2/cluster/netdebug.c
> @@ -151,7 +151,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
>  			   nst->st_send_time.tv_sec,
>  			   (unsigned long)nst->st_send_time.tv_usec,
>  			   nst->st_status_time.tv_sec,
> -			   nst->st_status_time.tv_usec);
> +			   (unsigned long)nst->st_status_time.tv_usec);

	suseconds_t is a signed long.  Can you change the format to %ld
and cast to long?  Unfortunately, we need the cast, as sparc64 and
parisc treat it as int.

Joel


-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
