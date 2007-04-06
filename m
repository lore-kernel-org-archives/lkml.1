Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXDFRjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXDFRjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbXDFRje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:39:34 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:30002 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbXDFRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:39:33 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
X-Message-Flag: Warning: May contain useful information
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 06 Apr 2007 10:39:29 -0700
In-Reply-To: <20070406173249.GA2517@elte.hu> (Ingo Molnar's message of "Fri, 6 Apr 2007 19:32:49 +0200")
Message-ID: <adaps6h767i.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Apr 2007 17:39:29.0379 (UTC) FILETIME=[873BB330:01C77872]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > no. Two _completely separate_ lists.
 > 
 > i.e. a to-be-reaped task will still be on the main list _too_. The main 
 > list is for all the PID semantics rules. The reap-list is just for 
 > wait4() processing. The two would be completely separate.

I guess this means we add another list head to struct task_struct.
Not that big a deal, but it does make me a little sad to think about
task_struct getting even bigger....

 - R.
