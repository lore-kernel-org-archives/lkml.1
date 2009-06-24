Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZFXD0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZFXD0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZFXDZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:25:54 -0400
Received: from ozlabs.org ([203.10.76.45]:53493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZFXDZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:25:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier race conditions
Date: Wed, 24 Jun 2009 12:55:54 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906241255.54709.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 03:33:22 am Davide Libenzi wrote:
> What you're doing there, is setting up a kernel-to-kernel (since
> userspace only role is to create the eventfd) communication, using a file*
> as accessory. That IMO is plain wrong.

The most sensible is that userspace can use these fds; an in-kernel variant is 
possible too, but not primary IMHO.

It's nice that userspace create the fds; it can then use the same fd for 
multiple event sources.

But I didn't see anything wrong with the way eventfd used to work: you have a 
kvm ioctl to say "attach this eventfd to this guest notification" and that does 
the eventfd_fget.  A detach ioctl does the fput (as does release of the kvm 
fd).

If they close the eventfd and don't do the detach ioctl, it's their problem.

Rusty.
