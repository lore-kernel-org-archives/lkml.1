Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXH2JoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXH2JoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 05:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXH2JoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 05:44:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:36238 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325AbXH2JoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 05:44:10 -0400
Date: Wed, 29 Aug 2007 12:03:13 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send quota messages via netlink
Message-ID: <20070829100313.GA7814@duck.suse.cz>
References: <20070828141318.GC5869@duck.suse.cz> <20070828215128.d8147a43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828215128.d8147a43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-08-07 21:51:28, Andrew Morton wrote:
> On Tue, 28 Aug 2007 16:13:18 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > +static void send_warning(const struct dquot *dquot, const char warntype)
> > +{
> > +	static unsigned long seq;
> > +	struct sk_buff *skb;
> > +	void *msg_head;
> > +	int ret;
> > +
> > +	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
> > +	if (!skb) {
> > +		printk(KERN_ERR
> > +		  "VFS: Not enough memory to send quota warning.\n");
> > +		return;
> > +	}
> > +	msg_head = genlmsg_put(skb, 0, seq++, &quota_genl_family, 0, QUOTA_NL_C_WARNING);
> 
> The access to seq is racy, isn't it?
> 
> If so, that can be solved with a lock, or with atomic_add_return().
  You're right. I've made atomic_t from seq. Thanks for spotting this.

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
