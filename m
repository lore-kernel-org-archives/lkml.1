Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYFWQAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYFWQAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYFWQAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:00:34 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:38518 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYFWQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:00:34 -0400
Message-ID: <485FC89A.30309@nortel.com>
Date: Mon, 23 Jun 2008 10:00:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: looking for explanation of select() timeout behaviour
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2008 16:00:31.0048 (UTC) FILETIME=[431F4C80:01C8D54A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got something odd in a recent strace log (running on an older 
kernel, I haven't yet tried to reproduce in mainline):

20418 22:06:50.583303 select(19, [7 11 12 13 14 15 16 17 18], NULL, 
NULL, {0, 498508}) = 1 (in [11], left {0, 0}) <5.074137>

select() was called with a timeout of half a second.  Five seconds later 
it returns with zero time left and a single socket readable.  Why 
wouldn't it have returned after half a second with a timeout?

My immediate suspicion would be to look at scheduler behaviour, but are 
there any other explanations?  I'm fairly sure system time wasn't 
changed during this interval (the system should have been ntp-synced).

Thanks,

Chris
