Return-Path: <linux-kernel-owner+w=401wt.eu-S965566AbXFFWot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbXFFWot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936012AbXFFWoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:44:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52835
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935879AbXFFWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:44:19 -0400
Date: Wed, 06 Jun 2007 15:44:34 -0700 (PDT)
Message-Id: <20070606.154434.21926922.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, drepper@redhat.com, mingo@elte.hu,
       dada1@cosmosbay.com
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
From: David Miller <davem@davemloft.net>
In-Reply-To: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Wed, 06 Jun 2007 15:30:31 -0700

> This patch implement a new syscall sys_socket2(), that accepts an
> extra "flags" parameter:
> 
> int socket2(int domain, int type, int protocol, int flags);
> 
> The flags parameter is used to pass extra flags to the kernel, and is
> at the moment used to select the file descriptor allocations inside
> the non-sequential area (O_NONSEQFD). The remaining parameters are
> exactly the same as the ones of sys_socket().
> The sys_accept() system call has been modified to return a file
> descriptor inside the non-sequential area, if the listening fd is.
> The sys_socketcall() system call has been also changed to support
> a new SYS_SOCKET2 indentifier.
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>

Since the valid range of "domain" values is quite small,
we could avoid the new system call by cribbing some of the
upper bits of the 'domain' argument.

Valid existing programs pass in valid 'domain' values and
thus will not set any of the new flags.

Just an idea.
