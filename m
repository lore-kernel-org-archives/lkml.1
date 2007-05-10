Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbXEJVVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbXEJVVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbXEJVVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:21:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56451
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbXEJVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:21:35 -0400
Date: Thu, 10 May 2007 14:21:38 -0700 (PDT)
Message-Id: <20070510.142138.54188362.davem@davemloft.net>
To: cebbert@redhat.com
Cc: croulder@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel BUG: NULL pointer dereference , reference to sys_recvmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <464389A2.6080606@redhat.com>
References: <547a31ab0705100712w740e8fbuece5013d05a449b9@mail.gmail.com>
	<464389A2.6080606@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>
Date: Thu, 10 May 2007 17:07:46 -0400

> Here in sys_recvmsg() line 1911:
> 
> ==>     if (sock->file->f_flags & O_NONBLOCK)
>                 flags |= MSG_DONTWAIT;
>         err = sock_recvmsg(sock, &msg_sys, total_len, flags);
> 
> sock == -1, apparently because that's what sockfd_lookup_light() 
> returned earlier in the function. (It doesn't check err, just
> that the returned sock is nonzero.)

sockfd_lookup_light() returns NULL in all cases where 'err'
is set non-zero.

I suspect file->private_data has been corrupted somehow.
