Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYLFQJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYLFQJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYLFQJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:09:29 -0500
Received: from tservice.ru ([195.178.208.66]:41947 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYLFQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:09:29 -0500
Date: Sat, 6 Dec 2008 19:09:27 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081206160927.GA498@ioremap.net>
References: <20081205180350.GA25236@ioremap.net> <20081205181610.518ecd13@lxorguk.ukuu.org.uk> <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com> <20081205192755.GA27712@ioremap.net> <20081205193432.290a6f1a@lxorguk.ukuu.org.uk> <20081205211223.GA8075@ioremap.net> <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com> <20081205212428.GB8075@ioremap.net> <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 03:10:33AM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> Can you add something like:
>   +++ b/kernel/kmod.c
>   @@ -108,6 +108,7 @@ int request_module(const char *fmt, ...)
>                   return -ENOMEM;
>           }
> 
>   +       printk("XXX call modprobe %s %s[%u]\n", module_name,
> current->comm, task_pid_nr(current));
> 
> It may show which process is looking for /dev/console and causes
> modprobe to run, and maybe we get an idea what's going on. It may at
> least show if it's a /dev/console problem.

Its a modprobe with different pids tries to load char-major-5 and
char-major-5-1 in the infinite loop.

-- 
	Evgeniy Polyakov
