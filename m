Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYAUTyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYAUTyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYAUTx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:53:56 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:44629 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYAUTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:53:54 -0500
Message-ID: <4794F848.9020402@nortel.com>
Date: Mon, 21 Jan 2008 13:53:44 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com>
In-Reply-To: <478654C3.60806@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jan 2008 19:53:47.0263 (UTC) FILETIME=[55E6B8F0:01C85C67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done some further digging, and it appears that one of the problems 
we may be facing is very high instantaneous traffic rates.

Instrumentation showed up to 222K packets/sec for short periods (at 
least 1.1 ms, possibly longer), although the long-term average is down 
around 14-16K packets/sec.

If I bump the rx ring size up to 4096, we can handle all the packets and 
we still have 44% idle on cpu0 and 27% idle on cpu1.

Is there anything else we can do to minimize the latency of network 
packet processing and avoid having to crank the rx ring size up so high?

Thanks,

Chris
