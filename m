Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYIOSCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYIOSCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYIOSCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:02:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38279 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbYIOSCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:02:42 -0400
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
Date: Mon, 15 Sep 2008 11:02:30 -0700
Message-Id: <1221501750.16561.15.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-13 at 19:06 -0400, Oren Laadan wrote:
> 
> +void *cr_hbuf_get(struct cr_ctx *ctx, int n)
> +{
> +       void *ptr;
> +
> +       BUG_ON(ctx->hpos + n > CR_HBUF_TOTAL);
> +       ptr = (void *) (((char *) ctx->hbuf) + ctx->hpos);
> +       ctx->hpos += n;
> +       return ptr;
> +}

All of the casting here is unnecessary.  'void *' behaves like 'char *'
when you do arithmetic on it.  

I really do detest having a memory allocator BUG_ON() when it runs out
of space.  

-- Dave

