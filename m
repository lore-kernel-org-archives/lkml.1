Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0BSVsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:48:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754Ab0BSVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:48:02 -0500
Date: Fri, 19 Feb 2010 13:45:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: [PATCH 5/8] ldisc n_tty: add new method n_tty_inherit_ops()
Message-Id: <20100219134535.51d47c25.akpm@linux-foundation.org>
In-Reply-To: <1266313885-1195-6-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
	<1266313885-1195-2-git-send-email-giometti@linux.it>
	<1266313885-1195-3-git-send-email-giometti@linux.it>
	<1266313885-1195-4-git-send-email-giometti@linux.it>
	<1266313885-1195-5-git-send-email-giometti@linux.it>
	<1266313885-1195-6-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 10:51:22 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

>  };
> +
> +void n_tty_inherit_ops(struct tty_ldisc_ops *ops)
> +{
> +	*ops = tty_ldisc_N_TTY;
> +	ops->owner = NULL;
> +	ops->refcount = ops->flags = 0;
> +}
> +EXPORT_SYMBOL_GPL(n_tty_inherit_ops);

Most (nearly all) functions in n_tty.c have been documented in
kerneldoc form.  Let's continue that please.

n_tty_inherit_ops() is of course pretty simple, but OTOH it's a global,
export-to-modules interface.

