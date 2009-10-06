Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbZJFUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbZJFUxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933362AbZJFUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:53:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933354AbZJFUxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:53:19 -0400
Date: Tue, 6 Oct 2009 13:49:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
       linux-fsdevel@vger.kernel.org, sage@newdream.net,
       viro@ZenIV.linux.org.uk, adilger@sun.com, hch@infradead.org,
       yehuda@newdream.net
Subject: Re: [PATCH 01/10] autofs4 - use macros for active list handling
Message-Id: <20091006134918.4d5dcbaf.akpm@linux-foundation.org>
In-Reply-To: <20091001010054.7675.77673.stgit@zeus.themaw.net>
References: <20091001010054.7675.77673.stgit@zeus.themaw.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Oct 2009 09:00:55 +0800
Ian Kent <raven@themaw.net> wrote:

> Define some simple macro functions for adding and deleting entries
> on the active (and unhashed) dentry list.

A "macro" is that thing which we create with #define.

> +static void autofs4_add_active(struct dentry *dentry)
> +{
> +	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> +	struct autofs_info *ino = autofs4_dentry_ino(dentry);
> +	if (ino) {
> +		spin_lock(&sbi->lookup_lock);
> +		if (!ino->active_count) {
> +			if (list_empty(&ino->active))
> +				list_add(&ino->active, &sbi->active_list);
> +		}
> +		ino->active_count++;
> +		spin_unlock(&sbi->lookup_lock);
> +	}
> +	return;
> +}
> +
> +static void autofs4_del_active(struct dentry *dentry)
> +{
> +	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> +	struct autofs_info *ino = autofs4_dentry_ino(dentry);
> +	if (ino) {
> +		spin_lock(&sbi->lookup_lock);
> +		ino->active_count--;
> +		if (!ino->active_count) {
> +			if (!list_empty(&ino->active))
> +				list_del_init(&ino->active);
> +		}
> +		spin_unlock(&sbi->lookup_lock);
> +	}
> +	return;
> +}

These aren't macros!  I changed the titles and changelogs of patches 1,
2 and 3 to use the term "helper functions".

