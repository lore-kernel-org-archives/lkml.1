Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZA2ImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZA2ImX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA2ImO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:42:14 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47445 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbZA2ImN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:42:13 -0500
Date: Thu, 29 Jan 2009 19:42:10 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, Michael Kerrisk <mtk.manpages@googlemail.com>,
       Bron Gondwana <brong@fastmail.fm>
Subject: Re: [patch] drop epoll max_user_instances and rely only on
	max_user_watches
Message-ID: <20090129084210.GA2704@brong.net>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 08:56:07PM -0800, Davide Libenzi wrote:
> Linus suggested to put limits where the money is, and max_user_watches 
> already does that w/out the need of max_user_instances. That has the 
> advantage to mitigate the potential DoS while allowing pretty generous 
> default behavior.
> Allowing top 4% of low memory (per user) to be allocated in epoll 
> watches, we have:
> 
> LOMEM    MAX_WATCHES (per user)
> 512MB    ~178000
> 1GB      ~356000
> 2GB      ~712000
> 
> A box with 512MB of lomem, will meet some challenge in hitting 180K 
> watches, socket buffers math teaches us.
> No more max_user_instances limits then.

Excellent.  Glad to see :)  Saves me from keeping on working on my "only
account epoll within epoll for max_user_instances" patch, which would
have just been needless complexity (though cheap - is_file_epoll looks
pretty easy to check for both descriptors) - and I hadn't even compiled
and tested it yet.

Thanks Davide - this will keep our mxes humming along happily.

Bron.
