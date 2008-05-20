Return-Path: <linux-kernel-owner+w=401wt.eu-S1765383AbYETSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765383AbYETSj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbYETSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:39:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:13575 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYETSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YLTKQMyOzymKqDIi4aT2cccFApaPrEDoQCAL2H6o0hAx6xSRcbOEenudzYWE6ZpRjFiJl/oHo9Phz9wux/JPQfkC125ry2phGuyWBJg5vuAtfL9yGCLRYlzitcLM11p+h8tp40wBKUHJqkPQ7Q40DteP9EMGNzGVKxJDsbFQOCk=
Date: Tue, 20 May 2008 22:39:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] eCryptFS race window?
Message-ID: <20080520183908.GB9623@cvg>
References: <20080520170321.GC6926@cvg> <20080520182757.GB32643@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520182757.GB32643@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Michael Halcrow - Tue, May 20, 2008 at 01:27:57PM -0500]
| On Tue, May 20, 2008 at 09:03:21PM +0400, Cyrill Gorcunov wrote:
| > it seems there is a few potential race window in eCryptFS which I
| > was trying to fix but it requires more deeper eCrypFS knowledge that
| > have (at least only by understanding eCryptFS in big picture it is
| > possible to fix this problem by elegant path). So what is the
| > problem - the procedures
| > 
| > 	ecryptfs_miscdev_poll
| > 	ecryptfs_miscdev_read
| > 
| > does take ecryptfs_daemon_hash_mux mutex and then daemon->mux _but_
| > releases them not in exactly backward order as it should. My patches
| > (not in mainline but you saw them) was screwed up 'cause
| > mutex_is_locked could release mutex acquired by another process and
| > that is wrong. But I've a hope that I'm simply *wrong* about this
| > possible races ;) Take a look please.
| 
| I cannot find an execution path whereby one of the two must re-acquire
| ecryptfs_daemon_hash_mux in order to release daemon->mux, so I do not
| think we will ever have deadlock between those two functions.
| 
| Mike
| 

ok, that means I'm just wrong, thanks

		- Cyrill -
