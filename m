Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXKTH7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXKTH7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXKTH7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:59:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47524
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbXKTH7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:59:45 -0500
Date: Mon, 19 Nov 2007 23:59:44 -0800 (PST)
Message-Id: <20071119.235944.82120402.davem@davemloft.net>
To: drepper@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Tue, 20 Nov 2007 01:53:14 -0500

FWIW, I think this indirect syscall stuff is the most ugly interface
I've ever seen proposed for the kernel.

And I agree with all of the objections raised by both H. Pater Anvin
and Eric Dumazet.

> This patch adds support for setting the O_NONBLOCK flag of the file
> descriptors returned by socket, socketpair, and accept.
 ...
> -	err = sock_attach_fd(sock1, newfile1);
> +	err = sock_attach_fd(sock1, newfile1,
> +			     INDIRECT_PARAM(file_flags, flags));

Where does this INDIRECT_PARAM() macro get defined?  I do not
see it being defined anywhere in these patches.

