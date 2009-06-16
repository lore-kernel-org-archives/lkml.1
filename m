Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZFPUiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZFPUiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZFPUir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:38:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbZFPUiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:38:46 -0400
Date: Tue, 16 Jun 2009 22:38:44 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
Message-ID: <20090616203844.GE23969@random.random>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <4A37EA92.7050509@redhat.com> <Pine.LNX.4.64.0906162035240.2933@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906162035240.2933@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 08:45:05PM +0100, Hugh Dickins wrote:
> liking the below better - what do you think?  If you approve, I'll send
> it in to Andrew for mmotm: I can't quite justify it without KSM.

I think it's definitely better to fix gup to be safe from kernel
thread even without KSM so this can go in mainline well before KSM.
Unless gup requires a swapin fault it won't ever trigger.
