Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbYLaAUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbYLaAUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYLaAUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:20:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYLaAUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:20:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, ebiederm@xmission.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6][v5] Protect cinit from unblocked SIG_DFL signals
In-Reply-To: Sukadev Bhattiprolu's message of  Saturday, 27 December 2008 12:53:19 -0800 <20081227205319.GC27337@us.ibm.com>
References: <20081227204658.GA27197@us.ibm.com>
	<20081227205319.GC27337@us.ibm.com>
X-Zippy-Says: I was in a HOT TUB!  I was NORMAL!  I was ITALIAN!!  I enjoyed th'
    EARTHQUAKE!
Message-Id: <20081231001942.F35E2FC278@magilla.sf.frob.com>
Date: Tue, 30 Dec 2008 16:19:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since you didn't add the sig_task_unkillable() helper for its one simple
condition in patch 2/6, I don't think you need it here either for two.
Just add '&& !from_ancestor_ns' inline.

This patch has more stray whitespace changes.  
I think checkpatch.pl will spot those for you.

I'd just make the flag a parameter to send_signal() directly.
Then you can just change kill_pid_info_as_uid (or its replacement)
to call send_signal() with that new flag (and the 'group' flag) 
directly instead of using the trivial __group_send_sig_info wrapper.


Thanks,
Roland
