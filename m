Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbXDJV6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbXDJV6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXDJV6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:58:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39843 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXDJV6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:58:45 -0400
X-IronPort-AV: i="4.14,391,1170662400"; 
   d="scan'208"; a="134168432:sNHT45531297"
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Milind Arun Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
X-Message-Flag: Warning: May contain useful information
References: <20070410181654.GA10525@arun.site>
	<Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
	<Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr>
	<ada7isjq52p.fsf@cisco.com>
	<Pine.LNX.4.64.0704101743520.24794@CPE00045a9c397f-CM001225dbafb6>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Apr 2007 14:58:37 -0700
In-Reply-To: <Pine.LNX.4.64.0704101743520.24794@CPE00045a9c397f-CM001225dbafb6> (Robert P. J. Day's message of "Tue, 10 Apr 2007 17:45:07 -0400 (EDT)")
Message-ID: <ada3b37q4c2.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2007 21:58:37.0985 (UTC) FILETIME=[6493B110:01C77BBB]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Don't worry about the __RAW_SPIN_LOCK_UNLOCKED stuff, that's
 > > obviously not for generic code to use.  The right answer (as I said
 > > before) is to use DEFINE_SPINLOCK().
 > 
 > that works fine if you're defining a single spinlock, but what do you
 > do in cases like this:
 > 
 > arch/sparc/lib/atomic32.c:      [0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
 > 
 > that is, when you're assigning an array of them?  you still need some
 > kind of generic, unnamed spinlock in those circumstances, no?

Wow, I didn't realize there was code doing that.  I guess for that
handful of cases, you indeed would probably want to convert them to
raw_spinlock_t and use __RAW_SPIN_LOCK_UNLOCKED.  But in the vast
majority of cases, DEFINE_SPINLOCK() is the right think to do.

 - R.
