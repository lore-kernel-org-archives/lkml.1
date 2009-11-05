Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZKEK5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZKEK5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZKEK5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:57:40 -0500
Received: from s2.homepagix.de ([91.199.241.131]:59242 "EHLO fry.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZKEK5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:57:39 -0500
Date: Thu, 5 Nov 2009 11:57:49 +0100
From: Max Kellermann <mk@cm4all.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] tcp: set SPLICE_F_NONBLOCK after first buffer has been
	spliced
Message-ID: <20091105105749.GA4901@rabbit.intern.cm-ag>
References: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag> <4AF2A929.3000201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF2A929.3000201@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/11/05 11:30, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I dont think this patch is correct. Could you describe your use case ?

See my second email, there's a demo source.

> If you dont want to block on output pipe, you should set this NONBLOCK 
> flag before calling splice(SPLICE_F_NONBLOCK) syscall.
> 
> ie : Use the socket in blocking mode, but output pipe in non-blocking mode.

Do you think that a splice() should block if the socket is readable
and the pipe is writable according to select()?

"The correct behavior would be to copy as much as possible, and return
without blocking.  Block only if nothing can be transferred."

Do you disagree with that?

> Some application could have a thread working in full blocking mode,
> and have another thread reading the pipe (and eventually unblocking
> first thread)

I don't get this objection.  Please explain.
