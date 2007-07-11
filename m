Return-Path: <linux-kernel-owner+w=401wt.eu-S1765524AbXGKVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765524AbXGKVNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbXGKVNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:13:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549AbXGKVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:13:08 -0400
Date: Wed, 11 Jul 2007 14:12:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [2.6.23 PATCH 01/18] dm: bio_list macro renaming
Message-Id: <20070711141247.6b852dc9.akpm@linux-foundation.org>
In-Reply-To: <20070711205635.GS24114@agk.fab.redhat.com>
References: <20070711205635.GS24114@agk.fab.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 21:56:35 +0100
Alasdair G Kergon <agk@redhat.com> wrote:

> From: Alasdair G Kergon <agk@redhat.com>
> 
> Rename BIO_LIST() macro to DEFINE_BIO_LIST(), named similarly to
> DEFINE_SPINLOCK().
> 
> Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> 
> ---
>  drivers/md/dm-bio-list.h |    2 +-
>  drivers/md/dm-delay.c    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/md/dm-bio-list.h
> ===================================================================
> --- linux.orig/drivers/md/dm-bio-list.h	2007-07-11 21:37:33.000000000 +0100
> +++ linux/drivers/md/dm-bio-list.h	2007-07-11 21:37:36.000000000 +0100
> @@ -22,7 +22,7 @@ static inline int bio_list_empty(const s
>  
>  #define BIO_LIST_INIT { .head = NULL, .tail = NULL }
>  
> -#define BIO_LIST(bl) \
> +#define DEFINE_BIO_LIST(bl) \
>  	struct bio_list bl = BIO_LIST_INIT
>  
>  static inline void bio_list_init(struct bio_list *bl)
> Index: linux/drivers/md/dm-delay.c
> ===================================================================
> --- linux.orig/drivers/md/dm-delay.c	2007-07-11 21:37:33.000000000 +0100
> +++ linux/drivers/md/dm-delay.c	2007-07-11 21:37:36.000000000 +0100
> @@ -83,7 +83,7 @@ static struct bio *flush_delayed_bios(st
>  	struct delay_info *delayed, *next;
>  	unsigned long next_expires = 0;
>  	int start_timer = 0;
> -	BIO_LIST(flush_bios);
> +	DEFINE_BIO_LIST(flush_bios);
>  
>  	mutex_lock(&delayed_bios_lock);
>  	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {

As there is only one caller, why not remove the unpleasant-looking
BIO_LIST and DEFINE_BIO_LIST altogether and just do

	struct bio_list flush_bios = { };

at that single callsite?
