Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZJITvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZJITvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761322AbZJITvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:51:20 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38359 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761306AbZJITvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:51:19 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R98dN936eM62a3Lzz1202hzzz32i2a8I6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KR9J3Q-02-D01-02
X-M-MSG: 
Date: Fri, 9 Oct 2009 21:50:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       David Rientjes <rientjes@google.com>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] oprofile: fix race condition in event_buffer free
Message-ID: <20091009195016.GH638@erda.amd.com>
References: <20091009160532.GD638@erda.amd.com>
 <1255116810-26514-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1255116810-26514-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Oct 2009 19:50:16.0559 (UTC) FILETIME=[B95117F0:01CA4919]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.10.09 21:33:29, Robert Richter wrote:
> From: David Rientjes <rientjes@google.com>
> 
> Looking at the 2.6.31-rc9 code, it appears there is a race condition
> in the event_buffer cleanup code path (shutdown). This could lead to
> kernel panic as some CPUs may be operating on the event buffer AFTER
> it has been freed. The attached patch solves the problem and makes
> sure CPUs check if the buffer is not NULL before they access it as
> some may have been spinning on the mutex while the buffer was being
> freed.
> 
> The race may happen if the buffer is freed during pending reads. But
> it is not clear why there are races in add_event_entry() since all
> workqueues or handlers are canceled or flushed before the event buffer
> is freed.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Ingo,

you can also pull the patches from here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

