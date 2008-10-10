Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbYJJOHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbYJJOHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbYJJOH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:07:29 -0400
Received: from zakalwe.fi ([80.83.5.154]:35956 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbYJJOH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:07:29 -0400
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 10:07:29 EDT
Date: Fri, 10 Oct 2008 16:43:51 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Ulrich Drepper <drepper@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mtk.manpages@gmail.com,
       Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: dup2() vs dup3() inconsistency when
Message-ID: <20081010134351.GL16289@zakalwe.fi>
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com> <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48EE6A2B.8030005@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 01:31:39PM -0700, Ulrich Drepper wrote:
> H. Peter Anvin wrote:
> > The dup2() behavior comes from the logical consequence of dup2()'s
> > "close on reuse"; one would think it would be logical for dup3() to
> > behave the same way.
> 
> No.  We deliberately decided on this change.  Otherwise, what is the
> result of dup3(fd, fd, O_CLOEXEC)?  There is no reason to use
> dup2(fd,fd), so why the hell somebody wants to defend this is beyond me.

The reason is: application programmers expect it to behave that way. 
The interface is mostly targeted for typical application programmers, 
and consistency decreases bugs. In this respect, it would be a good 
idea for dup3() to have the same semantics. Doing that might not make 
practical sense, but it is secondary to obviousness.

-- 
Heikki Orsila
heikki.orsila@iki.fi
http://www.iki.fi/shd
