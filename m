Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIXQDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIXQDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZIXQDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:03:52 -0400
Received: from fifo99.com ([67.223.236.141]:46525 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbZIXQDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:03:52 -0400
Subject: Re: [PATCH v18 20/80] c/r: basic infrastructure for
 checkpoint/restart
From: Daniel Walker <dwalker@fifo99.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>
In-Reply-To: <1253749920-18673-21-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	 <1253749920-18673-21-git-send-email-orenl@librato.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 09:03:41 -0700
Message-Id: <1253808221.20648.196.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 19:51 -0400, Oren Laadan wrote:
> /
> +static char *__ckpt_generate_fmt(struct ckpt_ctx *ctx, char *prefmt, char *fmt)
> +{
> +	static int warn_notask = 0;
> +	static int warn_prefmt = 0;

Shouldn't need the initializer since it's static..


> +/* read the checkpoint header */
> +static int restore_read_header(struct ckpt_ctx *ctx)
> +{
> +	struct ckpt_hdr_header *h;
> +	struct new_utsname *uts = NULL;
> +	int ret;
> +
> +	h = ckpt_read_obj_type(ctx, sizeof(*h), CKPT_HDR_HEADER);
> +	if (IS_ERR(h))
> +		return PTR_ERR(h);
> +
> +	ret = -EINVAL;
> +	if (h->magic != CHECKPOINT_MAGIC_HEAD ||
> +	    h->rev != CHECKPOINT_VERSION ||
> +	    h->major != ((LINUX_VERSION_CODE >> 16) & 0xff) ||
> +	    h->minor != ((LINUX_VERSION_CODE >> 8) & 0xff) ||
> +	    h->patch != ((LINUX_VERSION_CODE) & 0xff))
> +		goto out;

Do you still need this LINUX_VERSION_CODE stuff ? I would think once
it's in mainline you wouldn't need to track that..

These both got flagged by checkpatch .. Your series is marked in a
couple other places with checkpatch errors .. If you haven't already
reviewed those errors, it would be a good idea to review them.

Daniel


