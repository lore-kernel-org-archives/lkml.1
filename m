Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZKUVDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZKUVDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZKUVDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:03:32 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36190 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZKUVDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:03:32 -0500
Date: Sat, 21 Nov 2009 13:03:42 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Julia Lawall <julia@diku.dk>
cc: ceph-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [ceph-devel] [PATCH] fs/ceph: Move a dereference below a NULL
 test
In-Reply-To: <Pine.LNX.4.64.0911211652550.26930@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.0911211302440.15569@cobra.newdream.net>
References: <Pine.LNX.4.64.0911211652550.26930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereference should be moved below
> the NULL test.

I've applied this (and the previous patch) to the ceph tree.  

Thanks!
sage


> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/).
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/ceph/osd_client.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -u -p a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
> --- a/fs/ceph/osd_client.c
> +++ b/fs/ceph/osd_client.c
> @@ -1244,11 +1244,12 @@ int ceph_osdc_writepages(struct ceph_osd
>  static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  {
>  	struct ceph_osd *osd = con->private;
> -	struct ceph_osd_client *osdc = osd->o_osdc;
> +	struct ceph_osd_client *osdc;
>  	int type = le16_to_cpu(msg->hdr.type);
>  
>  	if (!osd)
>  		return;
> +	osdc = osd->o_osdc;
>  
>  	switch (type) {
>  	case CEPH_MSG_OSD_MAP:
> 
> ------------------------------------------------------------------------------
> Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
> trial. Simplify your report design, integration and deployment - and focus on 
> what you do best, core application coding. Discover what's new with
> Crystal Reports now.  http://p.sf.net/sfu/bobj-july
> _______________________________________________
> Ceph-devel mailing list
> Ceph-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ceph-devel
> 
> 
