Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbXFWQwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbXFWQwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759931AbXFWQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:52:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbXFWQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:52:35 -0400
Date: Sat, 23 Jun 2007 09:51:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Jones <tonyj@suse.de>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] audit: fix oops removing watch if audit disabled
Message-Id: <20070623095153.279c1194.akpm@linux-foundation.org>
In-Reply-To: <20070620223820.GA16416@suse.de>
References: <20070620223820.GA16416@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Jun 2007 15:38:20 -0700 Tony Jones <tonyj@suse.de> wrote:
> Removing a watched file will oops if audit is disabled (auditctl -e 0).
> 
> To reproduce:
> - auditctl -e 1
> - touch /tmp/foo
> - auditctl -w /tmp/foo
> - auditctl -e 0
> - rm /tmp/foo (or mv)
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>
> ---
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 74cc0fc..ce61f42 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -947,7 +947,7 @@ static void audit_update_watch(struct au
>  
>  		/* If the update involves invalidating rules, do the inode-based
>  		 * filtering now, so we don't omit records. */
> -		if (invalidating &&
> +		if (invalidating && current->audit_context &&
>  		    audit_filter_inodes(current, current->audit_context) == AUDIT_RECORD_CONTEXT)
>  			audit_set_auditable(current->audit_context);

This looks like 2.6.22 material to me.

Question is: is it also 2.6.21.x material?
