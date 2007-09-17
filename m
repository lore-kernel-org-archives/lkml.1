Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXIQRKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXIQRKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXIQRKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:10:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21867 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbXIQRKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:10:08 -0400
Subject: Re: [ofa-general] [PATCH] [WORKAROUND] CONFIG_PREEMPT_RT and
	ib_umad_close() issue
From: Daniel Walker <dwalker@mvista.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: John Blackwood <john.blackwood@ccur.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
In-Reply-To: <adaps0hnv5a.fsf@cisco.com>
References: <46EE9BCC.1040301@ccur.com>  <adaps0hnv5a.fsf@cisco.com>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 10:07:56 -0700
Message-Id: <1190048876.3253.41.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 08:56 -0700, Roland Dreier wrote:
> > When using OFED-1.2.5 based infiniband kernel modules on 2.6.22 based
>  > kernels with the Ingo Molnar CONFIG_PREEMPT_RT applied, then commands
>  > such as ibnetdiscvoer, smpquery, sminfo, etc. will hang.  The problem
>  > is with the downgrade_write() rw semaphore usage in the
>  > ib_umad_close() routine.
> 
> Can you give a few more details on how PREEMPT_RT changes locking
> rules (or just exposes existing bugs maybe?) so that the
> downgrade_write() causes the issue?  I would like to fix this cleanly
> but I don't really understand what the problem is.

the read/write semaphore functionality is basically reduced to just a
binary semaphore , i.e. one reader, or one writer . I think the BUG();
in downgrade_write() is likely part of a removal plan for
downgrade_write() (that's just a guess tho)

Daniel

