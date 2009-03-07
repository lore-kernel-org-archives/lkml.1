Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZCGBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZCGBLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 20:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZCGBLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 20:11:07 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59352 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbZCGBLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 20:11:06 -0500
X-IronPort-AV: E=Sophos;i="4.38,317,1233532800"; 
   d="scan'208";a="262917107"
From: Roland Dreier <rdreier@cisco.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add function spin_event_timeout()
References: <1236384801-10305-1-git-send-email-timur@freescale.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Mar 2009 17:11:00 -0800
In-Reply-To: <1236384801-10305-1-git-send-email-timur@freescale.com> (Timur
	Tabi's message of "Fri, 6 Mar 2009 18:13:21 -0600")
Message-ID: <adaiqmmf87v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2009 01:11:01.0061 (UTC) FILETIME=[944B4F50:01C99EC1]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The function spin_event_timeout() takes a condition and timeout value
 > (in jiffies) as parameters.  It spins until either the condition is true
 > or the timeout expires.  It returns non-zero if the condition is true,
 > zero otherwise.

What's the motivation for this?  Where do you plan to use it?

 > + * The function returns non-zero if the @condition evaluated to true, or

It's not a function but rather a macro.

 > +#define spin_event_timeout(condition, timeout)		\
 > +({							\
 > +	long __timeout = jiffies + (timeout);		\
 > +	while (!(condition) && (jiffies < __timeout));	\
 > +	(condition);					\
 > +})

If we're going to make this core infrastructure, it seems we should
implement it with all best practices... eg I would think the while loop
should include cpu_relax().
