Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZKENXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZKENXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZKENXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:23:43 -0500
Received: from s2.homepagix.de ([91.199.241.131]:56250 "EHLO fry.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbZKENXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:23:43 -0500
Date: Thu, 5 Nov 2009 14:23:52 +0100
From: Max Kellermann <mk@cm4all.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] tcp: set SPLICE_F_NONBLOCK after first buffer has been
	spliced
Message-ID: <20091105132352.GA14453@rabbit.intern.cm-ag>
References: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag> <4AF2A929.3000201@gmail.com> <20091105105749.GA4901@rabbit.intern.cm-ag> <4AF2B551.6010302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AF2B551.6010302@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/11/05 12:21, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Max Kellermann a écrit :
> > Do you think that a splice() should block if the socket is readable
> > and the pipe is writable according to select()?
> > 
> 
> Yes, this is perfectly legal
> 
> select() can return "OK to write on fd",
> and still, write(fd, buffer, 10000000) is supposer/allowed to block if fd is not O_NDELAY

>From the select() manpage: "those in writefds will be watched to see
if a write will not block"

>From the poll() manpage: "Writing now will not block."

This looks unambiguous to me, and contradicts with your thesis.  Can
you provide sources?

What is your interpretation of the guarantees provided by select() and
poll()?  Which byte count is "ok" to write after POLLOUT, and how much
is "too much"?  How does the application know?

> Please read recent commit on this area and why I think your patch
> conflicts with this commit.

I understand your patch, but I don't understand the conflict with my
patch.  Can you describe a breakage caused by my patch?
