Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYG2KLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYG2KLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYG2KLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:11:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36722 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758162AbYG2KLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:11:11 -0400
Date: Tue, 29 Jul 2008 10:53:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] proc tty: introduce ->proc_fops
Message-ID: <20080729105350.009f5af0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080729012908.GA3135@martell.zuzino.mipt.ru>
References: <20080729012908.GA3135@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 05:29:08 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Add struct tty_operations:proc_fops .
> 
> The intent is gradual switch of TTY drivers from ->read_proc usage.
> proc entries are created with proc_create_data() which even fixes
> early-read races.
> 
> Eventually ->read_proc code will be removed from TTY code, thus helping
> remove ->read_proc from whole proc code.

I'm going to NAK this but not because I think the concept is wrong. I
think the way its been done is perhaps wrong.

You've added ifdefs to a lot of drivers and more basically duplicate
code. Is there a reason you can't keep the ->read_proc method in the tty
code but as a function called by a single instance of proc_fops and
seq_file methods for the whole tty driver layer.

Ie have a single tty seq_file method that calls driver->ops->read_proc as
the seqfile iterator ?

>  int count, int *eof, void *data);
> +#ifdef CONFIG_PROC_FS
> +	const struct file_operations *proc_fops;
> +#endif

I'd prefer you didn't put variables in the middle of the methods. Also
the ifdef isn't needed. It's not worth one pointer to create a load of
ifdefs

Alan
