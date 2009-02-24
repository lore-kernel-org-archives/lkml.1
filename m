Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbZBXUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbZBXUp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbZBXUpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:45:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:50065 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbZBXUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:45:18 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 24 Feb 2009 12:45:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tony Battersby <tonyb@cybernetics.com>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] [2.6.29] epoll: fix for epoll_wait sometimes returning
 events on closed fds
In-Reply-To: <49A45A48.6020805@cybernetics.com>
Message-ID: <alpine.DEB.2.00.0902241241530.20039@alien.or.mcafeemobile.com>
References: <49A42DDE.8060605@cybernetics.com> <49A4387D.2020801@cosmosbay.com> <49A43FF0.2070703@cybernetics.com> <49A44FEB.6000803@cosmosbay.com> <49A45A48.6020805@cybernetics.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tony Battersby wrote:

> Ugh.  The manpage on Ubuntu 8.04 that I am using doesn't contain this
> lengthy caveat; it just says "A6     Yes."  To me it sounds like the
> (newer) manpage is just documenting away a bug/misfeature with "It's
> supposed to do that.  Gives it character." rather than expecting the
> kernel developers to make the API behave in a more reasonable way.  Just
> my opinion; others may agree or disagree.
> 
> If the officially-sanctioned epoll interface is supposed to report
> events on fds that were added, duped, and then the original fd closed,
> then my patch will probably break that behavior.  In that case, it will
> be more difficult to fix problem that my patch is trying to fix (which
> doesn't involve dup, dup2, fcntl, fork, etc.).  So before I try to think
> of another way, let me ask: do we want to fix the problem that I am
> reporting, or just document it away in the manpage as (apparently) has
> been done before?

No. Like it has been explained, MT applications can report events for 
closed files anyway. It is a matter of where the close() happen in time 
(pretty easy to figure out if you make a time/thread chart).
As for the other patches, some could be applied, but I didn't look at them 
deeply and I need time to review them. Will take time to review them 
tomorrow or the day after.



- Davide


