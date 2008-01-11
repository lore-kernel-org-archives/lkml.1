Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbYAKQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbYAKQdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbYAKQdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:33:01 -0500
Received: from as2.cineca.com ([130.186.84.242]:41848 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759734AbYAKQdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:33:00 -0500
Message-ID: <47879A32.8060508@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>
In-Reply-To: <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jan 2008 17:32:49 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> On Jan 11, 2008 4:15 AM, Andrea Righi <righiandr@users.sourceforge.net> wrote:
>> Allow to limit the bandwidth of I/O-intensive processes, like backup
>> tools running in background, large files copy, checksums on huge files,
>> etc.
>>
>> This kind of processes can noticeably impact the system responsiveness
>> for some time and playing with tasks' priority is not always an
>> acceptable solution.
>>
>> This patch allows to specify a maximum I/O rate in sectors per second
>> for each single process via /proc/<PID>/io_throttle (default is zero,
>> that specify no limit).
>>
>> Signed-off-by: Andrea Righi <a.righi@cineca.it>
> 
> Hi, Andrea,
> 
> We have been thinking of doing control group based I/O control. I have
> not reviewed your patch in detail. I can suggest looking at openvz's
> IO controller. I/O bandwidth control is definitely interesting. How
> did you test your solution?

I don't have meaningful values right now, just did some quick tests with
my pc. Regarding openvz it seems to use the CFQ priority-based approach
(with the 3 priority classes: real time, best effort and idle class).

The interesting feature is that it allows to set a priority for each
process container, but AFAIK it doesn't allow to "partition" the
bandwidth between different containers (that would be a nice feature
IMHO). For example it would be great to be able to define per-container
limits, like assign 10MB/s for processes in container A, 30MB/s to
container B, 20MB/s to container C, etc.

-Andrea
