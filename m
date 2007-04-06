Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXDFVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXDFVih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXDFVih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:38:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47125 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbXDFVif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:38:35 -0400
To: David Brownell <david-b@pacbell.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions
X-Message-Flag: Warning: May contain useful information
References: <11757099691323-git-send-email-tony@atomide.com>
	<200704061029.55710.david-b@pacbell.net>
	<46169968.2050006@s5r6.in-berlin.de>
	<200704061405.50169.david-b@pacbell.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 06 Apr 2007 14:38:25 -0700
In-Reply-To: <200704061405.50169.david-b@pacbell.net> (David Brownell's message of "Fri, 6 Apr 2007 14:05:49 -0700")
Message-ID: <adabqi16v5a.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Apr 2007 21:38:25.0559 (UTC) FILETIME=[E8432A70:01C77893]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[I can't believe I'm stepping into an indentation flamewar, but here goes...]

 > Please change your coding style to conform to Documentation/CodingStyle.
 > 
 > 	***	Only indent with tabs!!		***
 > 
 > Every one of those examples violates that simple rule.

Yes, Documentation/CodingStyle says that we should only indent with
tabs.  However, that simple rule has to be interpreted with some
common sense, and the case of multi-line if conditions is definitely a
case where using only tabs makes code much less readable.

If you want an excuse, you could say that in code like

	if (foo___________ &&
	    bar___________) {
 		doit;

that the line with "bar" on it is properly indented with one tab
(since it is part of the if statement that is also indented one tab),
and then four spaces are used to align the "bar" with the previous
line.  So only tabs are used for indentation, and the spaces after the
tab are used for alignment, and the letter of the law is observed.

If you have a git tree handy, you can do "git show 68380b58" and see
that Linus himself wrote:

	if (get_wq_data(work) == cwq
	    && work_pending(work)
	    && !list_empty(&work->entry)) {

I have to admit that I would have put the &&s at the ends of the
previous lines rather than where Linus put them, but... egads!  Linus
put spaces before the &&s to line them up nicely!

"more in the breach" and all that I guess...

 - R.
