Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYE3J2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYE3J2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYE3J15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:27:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbYE3J14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:27:56 -0400
Subject: Re: [PATCH] gfs2: trivial sparse lock annotations
From: Steven Whitehouse <swhiteho@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1212110871.28403.167.camel@brick>
References: <1212110871.28403.167.camel@brick>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 30 May 2008 10:27:42 +0100
Message-Id: <1212139662.3474.27.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw git tree. Thanks,

Steve.

On Thu, 2008-05-29 at 18:27 -0700, Harvey Harrison wrote:
> Annotate the &sdp->sd_log_lock.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/gfs2/log.c |    2 ++
>  fs/gfs2/log.h |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> index 548264b..6c6af9f 100644
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -87,6 +87,8 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
>   */
>  
>  static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
> +__releases(&sdp->sd_log_lock)
> +__acquires(&sdp->sd_log_lock)
>  {
>  	struct gfs2_bufdata *bd, *s;
>  	struct buffer_head *bh;
> diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
> index 7711528..7c64510 100644
> --- a/fs/gfs2/log.h
> +++ b/fs/gfs2/log.h
> @@ -21,6 +21,7 @@
>   */
>  
>  static inline void gfs2_log_lock(struct gfs2_sbd *sdp)
> +__acquires(&sdp->sd_log_lock)
>  {
>  	spin_lock(&sdp->sd_log_lock);
>  }
> @@ -32,6 +33,7 @@ static inline void gfs2_log_lock(struct gfs2_sbd *sdp)
>   */
>  
>  static inline void gfs2_log_unlock(struct gfs2_sbd *sdp)
> +__releases(&sdp->sd_log_lock)
>  {
>  	spin_unlock(&sdp->sd_log_lock);
>  }

