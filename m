Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYDWQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYDWQGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYDWQGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:06:41 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60842 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYDWQGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:06:40 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: Pull request for semaphore include changes
References: <20080419184029.GO20637@parisc-linux.org>
	<adawsmobm3f.fsf@cisco.com> <20080423160348.GA29796@parisc-linux.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Apr 2008 09:06:39 -0700
In-Reply-To: <20080423160348.GA29796@parisc-linux.org> (Matthew Wilcox's
	message of "Wed, 23 Apr 2008 10:03:49 -0600")
Message-ID: <adaskxcblo0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 16:06:39.0739 (UTC) FILETIME=[03AE54B0:01C8A55C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > You've missed this hunk:
 > 
 >         if (filp->f_flags & O_NONBLOCK) {
 >                 if (down_trylock(&port->sm_sem)) {
 >                         ret = -EAGAIN;
 >                         goto fail;
 >                 }
 >         } else {
 >                 if (down_interruptible(&port->sm_sem)) {
 >                         ret = -ERESTARTSYS;
 >                         goto fail;
 >                 }
 >         }

Duh, thanks.
