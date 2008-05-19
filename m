Return-Path: <linux-kernel-owner+w=401wt.eu-S1762403AbYESUmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbYESUmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYESUmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:42:04 -0400
Received: from vena.lwn.net ([206.168.112.25]:54046 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYESUmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:42:03 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 19 May 2008 13:38:48 PDT."
             <adahccu6nc7.fsf@cisco.com> 
Date: Mon, 19 May 2008 14:42:02 -0600
Message-ID: <19108.1211229722@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote:

> OK, will send such a patch after auditing more carefully.  Just to be
> very clear, the issue is to make sure the locking is sufficient to
> protect against multiple racing open calls to the same character device?

That's part of it, but, as Alan pointed out, there's more.  The BKL
currently protects open() calls against concurrency with other opens,
with ioctl(), and with driver initialization as well.  So it's a matter
of having one's locking and ordering act together in general.

jon
