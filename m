Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYIOSBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYIOSBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYIOSA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:00:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33685 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbYIOSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:00:56 -0400
Subject: Re: [RFC v5][PATCH 2/8] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-3-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 11:00:52 -0700
Message-Id: <1221501652.16561.12.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
> 
> +
> +struct cr_ctx *cr_ctx_alloc(pid_t pid, int fd, unsigned long flags)
> +{
> +       struct cr_ctx *ctx;
> +
> +       ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +       if (!ctx)
> +               return ERR_PTR(-ENOMEM);
> +
> +       ctx->file = fget(fd);
> +       if (!ctx->file) {
> +               cr_ctx_free(ctx);
> +               return ERR_PTR(-EBADF);
> +       }
> +
> +       ctx->hbuf = (void *) __get_free_pages(GFP_KERNEL, CR_HBUF_ORDER);
> +       if (!ctx->hbuf) {
> +               cr_ctx_free(ctx);
> +               return ERR_PTR(-ENOMEM);
> +       }

Could you explain why you're not using the slab here?

-- Dave

