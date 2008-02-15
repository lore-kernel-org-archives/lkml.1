Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbYBOI7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbYBOI7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYBOI7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:59:13 -0500
Received: from mail.transmode.se ([83.241.175.147]:52704 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754930AbYBOI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:59:12 -0500
Subject: RE: Abnormal behavior with JFFS2 on latest kernel
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: kmpark@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <005001c86fb0$b9bc6d00$1fa9580a@swcenter.sec.samsung.co.kr>
References: <004601c86fa2$201a78d0$1fa9580a@swcenter.sec.samsung.co.kr>
	 <1203065237.5419.74.camel@gentoo-jocke.transmode.se>
	 <005001c86fb0$b9bc6d00$1fa9580a@swcenter.sec.samsung.co.kr>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Fri, 15 Feb 2008 09:59:11 +0100
Message-Id: <1203065951.5419.84.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 17:56 +0900, Kyungmin Park wrote:
> > > I got following messages.
> > > INFO: task pdflush:56 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > >
> > > What are the meanings?
> > > Too mush running GC in JFFS2 or others?
> > >
> > > BR,
> > > Kyungmin Park
> > 
> > It is probably erasing lots of blocks and that takes a while, minutes
> > some times. I once sent a patch to address this but the patch is racy
> > w.r.t module unload. Look in the archive after patches from me.
> > 
> 
> You mean this one?
> diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
> index d1d4f27..b2e71c7 100644
> --- a/fs/jffs2/wbuf.c
> +++ b/fs/jffs2/wbuf.c
> @@ -115,7 +115,7 @@ static inline void jffs2_refile_wbuf_blocks(struct jffs2_sb_
> 
>                 D1(printk(KERN_DEBUG "Removing eraseblock at 0x%08x from erasabl
>                 list_del(this);
> -               if ((jiffies + (n++)) & 127) {
> +               if ((jiffies + (n++)) & 127 && !list_empty(&c->erasable_list)) {
>                         /* Most of the time, we just erase it immediately. Other
>                            spend ages scanning it on mount, etc. */
>                         D1(printk(KERN_DEBUG "...and adding to erase_pending_lis
> 
> It's already applied, but it's same.

Nope, the patch is probably named 
"[JFFS2] Stop erasing blocks when rebooting."

  Jocke
