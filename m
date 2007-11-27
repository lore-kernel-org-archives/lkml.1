Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbXK0JDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbXK0JDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXK0JDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:03:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbXK0JDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:03:37 -0500
Date: Tue, 27 Nov 2007 01:02:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Timerfd v3 - new timerfd API
Message-Id: <20071127010254.133e222f.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.18989.1196028860.2>
References: <send-serie.davidel@xmailserver.org.18989.1196028860.2>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 14:14:19 -0800 Davide Libenzi <davidel@xmailserver.org> wrote:

> +static struct file *timerfd_fget(int fd)
> +{
> +	struct file *file;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return ERR_PTR(-EBADF);
> +	if (file->f_op != &timerfd_fops) {
> +		fput(file);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	return file;
> +}

I suppose we could use fget_light() in here sometime.  It is significantly
quicker in microbenchmarks.  Or it was - nobody has checked that in a few
years afaik.
