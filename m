Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbXJGT4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbXJGT4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXJGT4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:56:21 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63534 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbXJGT4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:56:19 -0400
To: a.p.zijlstra@chello.nl
Cc: junwang1234@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Sleeping in RCU list traversal
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1191784307.3618.8.camel@localhost.localdomain>
	<200710072226.EJF51558.LFVHJOStFOOFMQ@I-love.SAKURA.ne.jp>
	<1191796640.3045.25.camel@localhost.localdomain>
	<200710080156.IFB56934.tHMLFFJSFOVOOQ@I-love.SAKURA.ne.jp>
	<1191781996.5587.3.camel@lappy>
In-Reply-To: <1191781996.5587.3.camel@lappy>
Message-Id: <200710080456.DFE30787.OJFtFHMLFSOQOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 8 Oct 2007 04:56:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Peter Zijlstra wrote:
> > So, I don't need to grab a reference to "ptr"
> > because memory region pointed by "ptr" will never be kfree()ed.
> > And it is legal to use "ptr" after rcu_read_unlock()
> > because memory region pointed by "ptr" will never be kfree()ed.
> 
> Still think that is a very BAD (tm) idea. Esp since with the help of RCU
> there is hardly any performance loss of not doing proper deletes.
> 
Elements I keep in RCU list are policy table for access control
that are referred throughout the lifetime of the kernel.
So, there is hardly any needs to delete these elements.
Honestly speaking, I don't need to use RCU list at all.
Just using a singly linked list that doesn't support deletion is enough.
But James Morris advises me to use the existing API
( http://lkml.org/lkml/2007/10/2/156 http://lkml.org/lkml/2007/10/3/124 ).

Thank you.

