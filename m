Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYJAVhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYJAVhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYJAVg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:36:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38324 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753612AbYJAVg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:36:58 -0400
Date: Wed, 1 Oct 2008 22:36:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Steven Noonan <steven@uplinklabs.net>
Subject: Re: [PATCH] drivers/serial/8250.c: 'i' may be used uninitialized
Message-ID: <20081001223645.23ad0e5e@lxorguk.ukuu.org.uk>
In-Reply-To: <1222850827-30522-1-git-send-email-steven@uplinklabs.net>
References: <f488382f0810010136t6280c10dg80458e3e9f02f598@mail.gmail.com>
	<1222850827-30522-1-git-send-email-steven@uplinklabs.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2008 01:47:07 -0700
Steven Noonan <steven@uplinklabs.net> wrote:

> serial_unlink_irq_chain() does not initialize iterator 'i', and that is
> correct logically because it is always initialized, either in the
> hlist_for_each or in the conditional immediately after (which fires if
> hlist_for_each comes up empty-handed). GCC does not realize this
> connection and emits a false warning. Annotate it with uninitialized_var().
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

Ok definitive NAK. gcc 4.3.0 can work this out and doesn't produce a
warning. Thanks for sending the patch though (and to the gcc folks for
rendering it unnecessary)

Alan
