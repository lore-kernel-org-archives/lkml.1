Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXCLHyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXCLHyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 03:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXCLHyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 03:54:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXCLHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 03:54:08 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: sys_write() racy for multi-threaded append?
To: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Mon, 12 Mar 2007 08:53:31 +0100
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WAx2-2pg-21@gated-at.bofh.it> <7WAGF-2Bx-9@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it> <7WBt7-3SZ-23@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HQfLX-0000fk-68@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18VlNqo7Q5uQPGRSd8UaVYocTviqn9yp1TF4Q4
 9kYKtIlUTjZxqA4UH2jrshACG/DR6JmZ/GT2zYU/HiEtKelH/2
 W+HUA35jHb9VAoTXTpjfw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards <medwards.linux@gmail.com> wrote:

> On 3/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> Absolutely not. We dont want to slow down kernel 'just in case a fool might
>> want to do crazy things'
> 
> Actually, I think it would make the kernel (negligibly) faster to bump
> f_pos before the vfs_write() call.

This is a security risk.

----------------
other process:
unlink(secrest_file)

Thread 1:
write(fd, large)
(interrupted)

Thread 2:
fseek(fd, -n, relative)
read(fd, buf)
----------------

BTW: The best thing you can do to a program where two threads race for
writing one fd is to let it crash and burn in the most spectacular way
allowed without affecting the rest of the system, unless it happens to
be a pipe and the number of bytes written is less than PIPE_MAX.
-- 
The secret of the universe is #@*%! NO CARRIER 

Friﬂ, Spammer: dyIw3Rs@x.7eggert.dyndns.org PLxmr@lv.7eggert.dyndns.org
 HmiJuSaiuF@b.7eggert.dyndns.org rKjmsxE@7eggert.dyndns.org
