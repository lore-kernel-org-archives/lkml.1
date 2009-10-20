Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbZJTA6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbZJTA6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437AbZJTA6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:58:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37642 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbZJTA6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:58:10 -0400
Date: Tue, 20 Oct 2009 02:58:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 3/5] cfq-iosched: reimplement priorities using
	different service trees
Message-ID: <20091020005813.GD10727@kernel.dk>
References: <200910192221.23564.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910192221.23564.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> We use different service trees for different priority classes.
> This allows a simplification in the service tree insertion code, that no
> longer has to consider priority while walking the tree.

> +enum wl_prio_t {
> +	IDLE_WL = -1,
> +	BE_WL = 0,
> +	RT_WL = 1
> +};

WL?

> +static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
> +					struct cfq_data *cfqd)
> +{
> +	return prio == IDLE_WL ? &cfqd->service_tree_idle :
> +		&cfqd->service_trees[prio];
> +}

Don't do it...

static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
					struct cfq_data *cfqd)
{
        if (prio == IDLE_WL)
                return &cfqd->service_tree_idle;

        return &cfqd->service_trees[prio];
}

much cleaner. There are more of these in this patch.

Otherwise it looks sane, and I agree that making the insert cleaner here
is a good bonus.

-- 
Jens Axboe

