Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYA0GBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYA0GBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYA0GBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:01:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYA0GBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:01:03 -0500
Date: Sat, 26 Jan 2008 22:00:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Teigland <teigland@redhat.com>
Cc: linux-kernel@vger.kernel.org, fabbione@ubuntu.com
Subject: Re: [PATCH 06/19] dlm: align midcomms message buffer
Message-Id: <20080126220023.4d1256b6.akpm@linux-foundation.org>
In-Reply-To: <1201193442-8260-7-git-send-email-teigland@redhat.com>
References: <1201193442-8260-7-git-send-email-teigland@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 10:50:29 -0600 David Teigland <teigland@redhat.com> wrote:
> From: Fabio M. Di Nitto <fabbione@ubuntu.com>
> 
> gcc does not guarantee that a static buffer is 64bit aligned. This change
> allows sparc64 to work.
> 

This buffer is not static: changelog needs fixing: s/static/auto/

> ---
>  fs/dlm/midcomms.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
> index f8c69dd..da653b5 100644
> --- a/fs/dlm/midcomms.c
> +++ b/fs/dlm/midcomms.c
> @@ -58,7 +58,7 @@ static void copy_from_cb(void *dst, const void *base, unsigned offset,
>  int dlm_process_incoming_buffer(int nodeid, const void *base,
>  				unsigned offset, unsigned len, unsigned limit)
>  {
> -	unsigned char __tmp[DLM_INBUF_LEN];
> +	unsigned char __tmp[DLM_INBUF_LEN] __attribute__((aligned(64)));
>  	struct dlm_header *msg = (struct dlm_header *) __tmp;
>  	int ret = 0;
>  	int err = 0;

Why does DLM require that this thing be 64-bit aligned?

It all looks rather ugly.  Can't this stuff be implemeted within the C type
system somehow?
