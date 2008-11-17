Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbYKQPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbYKQPhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYKQPhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:37:34 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:62575 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYKQPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:37:33 -0500
Message-ID: <49218FB4.6090805@nortel.com>
Date: Mon, 17 Nov 2008 09:37:24 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: busted CFS group load balancer?
References: <20081115011452.GA28135@google.com>
In-Reply-To: <20081115011452.GA28135@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2008 15:37:25.0700 (UTC) FILETIME=[641D3840:01C948CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> It appears that the fair-group load balancer in 2.6.27 does not work
> properly.

There was an issue fixed post 2.6.27 where the load balancer didn't work 
properly if there was one task per group per cpu.  You might try 
backporting commit 38736f4 and see if that helps.

Also, caea8a0 fixes up list traversal in load_balance_fair() to use the 
_rcu() version.  I'm not aware of this causing any problems in practice, 
but it might be worth a try.

Chris
