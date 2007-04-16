Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbXDPRqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbXDPRqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXDPRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:46:37 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:19685 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXDPRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:46:35 -0400
X-IronPort-AV: i="4.14,415,1170662400"; 
   d="scan'208"; a="478548692:sNHT44817812"
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrw Morton <akpm@linux-foundation.org>
Subject: Re: [KJ][PATCH]Rocket port:use mutex instead of binary  semaphore
X-Message-Flag: Warning: May contain useful information
References: <20070416174155.GA9314@arun.site>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Apr 2007 10:46:26 -0700
In-Reply-To: <20070416174155.GA9314@arun.site> (Milind Arun Choudhary's message of "Mon, 16 Apr 2007 23:11:55 +0530")
Message-ID: <adabqho8b65.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Apr 2007 17:46:27.0083 (UTC) FILETIME=[2855C5B0:01C7804F]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > -	down_interruptible(&info->write_sem);
 > +	if(mutex_lock_interruptible(&info->write_lock)){
 > +		return -ERESTARTSYS;
 > +	}

1) This is a semantic change.  Of course using down_interruptible()
without checking the return value is almost certainly a bug, but have
you thought about whether returning ERESTARTSYS is correct here?  If
you have, then please include the reasoning in your patch description.
(Another possibility would be to just use an uninterruptible mutex_lock())

2) The coding style for the if statement is not quite right.  The
correct way is to do

	if (condition)
		one_liner;

(note the space between the 'if' and the '(', and no braces used)

 - R.
