Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbYFTHP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbYFTHP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYFTHPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:15:47 -0400
Received: from main.gmane.org ([80.91.229.2]:56714 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYFTHPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:15:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Bisecting tip/auto-x86-next?
Date: Fri, 20 Jun 2008 07:15:30 +0000 (UTC)
Message-ID: <g3flei$653$1@ger.gmane.org>
References: <485AFC9B.7090502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 21:40:59 -0300, Kevin Winchester wrote:

> I am trying to track down a problem I reported here:
> 
> http://lkml.org/lkml/2008/6/11/431
> 
[...]
>
> that ruin the process?  Can I manually choose a bisection point right
> after this warning was fixed?  Is it likely that the fix for this

You certainly can move the bisection point. If you look at man git-bisect 
it will mention the following:

"Avoiding to test a commit
If in a middle of bisect session, you know what the bisect suggested to
try next is not a good one to test (e.g. the change the commit
introduces is known not to work in your environment and you know it
does not have anything to do with the bug you are chasing), you may
want to find a near-by commit and try that instead.

It goes something like this:

   $ git bisect good/bad                   # previous round was good/bad.
   Bisecting: 337 revisions left to test after this
   $ git bisect visualize                  # oops, that is uninteresting.
   $ git reset --hard HEAD~3               # try 3 revs before what
					   # was suggested

Then compile and test the one you chose to try. After that, tell bisect
what the result was as usual."

It can be helpful to use gitk on the point that git bisect chooses/git 
bisect visualise to see a graphical view of what's around it and then use 
git reset <commitrev> to move yourself to a particular commit. You can 
still use git bisect good/bad when you have moved to a particular commit 
so long as the bisection processes has started.

-- 
Sitsofe | http://sucs.org/~sits/

