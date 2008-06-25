Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYFYXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYFYXl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbYFYXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:41:41 -0400
Received: from vena.lwn.net ([206.168.112.25]:59976 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbYFYXlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:41:40 -0400
Date: Wed, 25 Jun 2008 17:41:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: remove BKL for ioctl()
Message-ID: <20080625174139.62a0d07f@bike.lwn.net>
In-Reply-To: <20080625233017.5b207e94@lxorguk.ukuu.org.uk>
References: <200806221955.42597.david-b@pacbell.net>
	<20080625163928.4da1f4a0@bike.lwn.net>
	<20080625233017.5b207e94@lxorguk.ukuu.org.uk>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 23:30:17 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> For an ioctl case which should never be blocking for long periods it
> shouldn't be _interruptible in the first place, that will just
> introduce bizarre and weird bugs in application code.

OTOH, my sysadmin youth left me with some painful memories of having to
reboot important systems to get rid of a process with some vital
resource in a D-state death grip.  So I have a certain aversion to
putting uninterruptible waits in places where they aren't really
necessary.

Perhaps this is a good candidate for mutex_lock_killable()?

jon
