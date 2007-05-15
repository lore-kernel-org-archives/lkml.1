Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbXEOHXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbXEOHXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbXEOHXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:23:24 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:36736 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761900AbXEOHXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:23:23 -0400
Message-ID: <46495FD4.9080607@linux.vnet.ibm.com>
Date: Tue, 15 May 2007 12:53:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: Paul Menage <menage@google.com>, vatsa@in.ibm.com,
       linux-kernel@vger.kernel.org, xemul@sw.ru, akpm@linux-foundation.org,
       devel@openvz.org
Subject: Re: [RFC][PATCH] Per container statistics
References: <20070514174454.15338.67171.sendpatchset@balbir-laptop> <46495D4C.7040401@sw.ru>
In-Reply-To: <46495D4C.7040401@sw.ru>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
> oh, please no... Andrew, this loop can be very very long when having > 10,000 tasks on the machine...
> we have had enough such issues in OpenVZ and just don't want to come through this again.
> Also sum of RUNNING + UNINTERRUPTIBLE is required for per-container loadavg calculations.
> 

Hi, Kirill,

I've asked Paul Menage to help us with this scenario by adding a per-container task list.
Would you be ok, if we walked the per-container task list. We could further optimize
the routine by adding

1. A container id (avoid parsing file paths to uniquely identify a container)
2. If we cannot do (1), then cache container paths

The other option is of-course what Pavel posted, but I think the amortized cost of tracking
task state at the time of task state change or looping over tasks on demand should be the
same.

Do you agree in general with containerstats? How we build (walk the task list or at the
time of task state change) is flexible with containerstats.

Thanks for your comments!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
