Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZBXQAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZBXQAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbZBXQAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:00:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48125 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZBXQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:00:24 -0500
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Andi Kleen <andi@firstfloor.org>
References: <20090216120213.GB3925@linux.vnet.ibm.com>
	<1234787082.30178.3.camel@laptop>
	<20090216131440.GC3925@linux.vnet.ibm.com>
	<20090216132014.GD3925@linux.vnet.ibm.com>
	<4999BC0C.1010304@fatooh.org>
	<20090217050033.GA10409@linux.vnet.ibm.com>
	<20090217101542.GB15989@linux.vnet.ibm.com>
	<1234869339.4744.77.camel@laptop>
	<20090223114541.GD31277@linux.vnet.ibm.com>
	<1235390396.4645.87.camel@laptop>
	<20090224091849.GA18693@linux.vnet.ibm.com>
Date: Tue, 24 Feb 2009 16:58:44 +0100
In-Reply-To: <20090224091849.GA18693@linux.vnet.ibm.com> (Dhaval Giani's message of "Tue, 24 Feb 2009 14:48:49 +0530")
Message-ID: <874oyj4yiz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani <dhaval@linux.vnet.ibm.com> writes:
>  		new->euid = euid;
> Index: linux-2.6/include/asm-generic/errno.h
> ===================================================================
> --- linux-2.6.orig/include/asm-generic/errno.h
> +++ linux-2.6/include/asm-generic/errno.h
> @@ -106,4 +106,6 @@
>  #define	EOWNERDEAD	130	/* Owner died */
>  #define	ENOTRECOVERABLE	131	/* State not recoverable */
>  
> +#define ENOTIME		132	/* No time available to run process */

It's normally not a good idea to add new errnos, because old glibc's
strerror()s won't know about it.

There are also so many around that you surely will find an existing
one which sounds appropiate.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
