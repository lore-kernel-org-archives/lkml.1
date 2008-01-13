Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbYAMLzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbYAMLzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 06:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYAMLzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 06:55:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYAMLzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 06:55:00 -0500
Date: Sun, 13 Jan 2008 06:54:53 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] NLM: Have lockd call try_to_freeze
Message-ID: <20080113065453.4774f8dd@tleilax.poochiereds.net>
In-Reply-To: <1199988096-19700-4-git-send-email-jlayton@redhat.com>
References: <1199988096-19700-1-git-send-email-jlayton@redhat.com>
	<1199988096-19700-2-git-send-email-jlayton@redhat.com>
	<1199988096-19700-3-git-send-email-jlayton@redhat.com>
	<1199988096-19700-4-git-send-email-jlayton@redhat.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 13:01:34 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> lockd makes itself freezable, but never calls try_to_freeze(). Have it
> call try_to_freeze() within the main loop.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/lockd/svc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
> index 82e2192..6ee8bed 100644
> --- a/fs/lockd/svc.c
> +++ b/fs/lockd/svc.c
> @@ -155,6 +155,9 @@ lockd(struct svc_rqst *rqstp)
>  		long timeout = MAX_SCHEDULE_TIMEOUT;
>  		char buf[RPC_MAX_ADDRBUFLEN];
>  
> +		if (try_to_freeze())
> +			continue;
> +
>  		if (signalled()) {
>  			flush_signals(current);
>  			if (nlmsvc_ops) {


I was looking over svc_recv today and noticed that it calls
try_to_freeze a couple of times. Given that, the above patch may be
unnecessary. I don't think it hurts anything though. Should we keep
this patch or drop it?

-- 
Jeff Layton <jlayton@redhat.com>
