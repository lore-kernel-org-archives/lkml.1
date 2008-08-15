Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYHOLjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYHOLjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYHOLi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:38:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYHOLi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:38:57 -0400
Date: Fri, 15 Aug 2008 13:38:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msr: Fix NULL pointer deref due to msr_open on
	nonexistent CPUs
Message-ID: <20080815113842.GB31348@elte.hu>
References: <20080814224333.GG28450@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814224333.GG28450@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darrick J. Wong <djwong@us.ibm.com> wrote:

> msr_open tests for someone trying to open a device for a nonexistent CPU.
> However, the function always returns 0, not ret like it should, hence userspace
> can BUG the kernel trivially.  This bug was introduced by the cdev lock_kernel
> pushdown patch last May.
> 
> The BUG can be reproduced with these commands:
> 
> # mknod fubar c 202 8 <-- pick a number less than NR_CPUS that is not
>                           the number of an online CPU
> # cat fubar

applied to tip/x86/urgent - thanks Darrick.

	Ingo
