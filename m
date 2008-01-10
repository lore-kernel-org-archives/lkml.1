Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYAJVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYAJVan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYAJVae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:30:34 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:52577 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYAJVac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:30:32 -0500
Message-ID: <47868E28.1070600@nortel.com>
Date: Thu, 10 Jan 2008 15:29:12 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: James Chapman <jchapman@katalix.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <47866327.8090905@katalix.com>
In-Reply-To: <47866327.8090905@katalix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2008 21:29:15.0559 (UTC) FILETIME=[D9B01370:01C853CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Chapman wrote:

> What's changed in your application? Any real-time threads in there?
> 
>>From the top output below, looks like SigtranServices is consuming all
> your CPU...

There are two cpus, and SigtranServices is multithreaded with many 
threads.  Most of these threads are affined to cpu0, a couple to cpu1. 
None of the threads are realtime.

Top is showing 37% idle on cpu0, and 6% idle on cpu1, so not all the cpu 
is being consumed.  However, I'm wondering if we're hitting bursty bits 
and we're just running out of time.

I'm going to try a system with MAX_SOFTIRQ_RESTART bumped up a bit, and 
also enable profiling.

Chris
