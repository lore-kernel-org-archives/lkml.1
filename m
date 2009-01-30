Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbZA3AKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbZA3AKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZA3AKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:10:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38131 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZA3AKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:10:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 16:10:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Howard Chu <hyc@symas.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll optimizations
In-Reply-To: <4981C648.3000108@symas.com>
Message-ID: <alpine.DEB.1.10.0901291606260.16141@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061628470.3661@alien.or.mcafeemobile.com> <4981C648.3000108@symas.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Howard Chu wrote:

> Something I tripped over recently, that might be nice to change... HANGUP
> events are always reported, and apparently can't be turned off. In
> level-triggered mode, if your event loop treats Hangups as lower priority than
> read/write events, an outstanding Hangup will continue to be signaled every
> time you call epoll_wait() until it's finally disposed of. It would be nice if
> Hangups were always oneshot events, regardless of whether the FD was
> configured level, edge, or oneshot. Certainly we know that the *cause* of a
> Hangup can only happen once on any descriptor, so it makes no sense for it to
> be reported more than once.

Since epoll does not have the concept of priority, that means that you 
have to scan the whole array of returned events anyway. It is sufficient 
that when you notice a POLLHUP, you do a quick handling with a simple 
epoll_ctl(DEL), append the fd to a lazy-handling queue, and take care of 
it when time comes.



- Davide


