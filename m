Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbXJASRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbXJASRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJASQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:16:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32914 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXJASQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:16:54 -0400
Date: Mon, 1 Oct 2007 19:16:48 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
Message-ID: <20071001181648.GB8181@ftp.linux.org.uk>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <200710010058.49242.vda.linux@googlemail.com> <Pine.LNX.4.64.0709301709490.19355@alien.or.mcafeemobile.com> <200710011107.15846.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710011107.15846.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 11:07:15AM +0100, Denys Vlasenko wrote:
> Also attached is ndelaytest.c which can be used to test that
> send(MSG_DONTWAIT) indeed is failing with EAGAIN if write would block
> and that other processes never see O_NONBLOCK set.
> 
> Comments?

Never send patches during or approaching hangover?
	* it's on a bunch of cyclic lists.  Have its neighbor
go away while you are doing all that crap => boom
	* there's that thing call current position...  It gets buggered.
	* overwriting it while another task might be in the middle of
syscall involving it => boom
	* non-cooperative tasks reading *in* *parallel* from the same
opened file are going to have a lot more serious problems than agreeing
on O_NONBLOCK anyway, so I really don't understand what the hell is that for.

