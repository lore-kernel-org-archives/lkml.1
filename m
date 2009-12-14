Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbZLNXZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbZLNXZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZLNXZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:25:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:38168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbZLNXZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:25:18 -0500
Message-ID: <4B26C95A.8000708@kernel.org>
Date: Tue, 15 Dec 2009 08:25:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Warn people about flush_scheduled_work()
References: <Pine.LNX.4.44L0.0912141809390.2690-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912141809390.2690-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2009 08:14 AM, Alan Stern wrote:
>> I think both problems can be detected by lockdep, right?  So, they
>> aren't that difficult to detect.
> 
> Maybe they can, now.  It used to be they couldn't.

I think they can now.  Workqueue workers acquire pseudo lock known to
lockdep around execution of a work function and flush_workqueue()
grabs and releases the pseudo lock too, so both are known to lockdep.

> However, lockdep doesn't help much -- it tells you the cause of the
> deadlock but it doesn't prevent the deadlock from occurring.  The
> programmer has to do this, by avoiding flush_scheduled_work().  I guess 
> that could be added to the comment.

As lockdep computes deadlocks from all possible combinations, it
usually detects deadlocks pretty quickly during devel cycle, so it
doesn't prevent them from happening but still helps a lot.

>> Yeah, recommending more work-specific constructs definitely would be
>> better.  It's bad that we can't recommend the use of flush_work() as
>> it doesn't do cross-cpu flushing.  Maybe that needs explanation too.
> 
> I'll do my comments, and you can do yours.  :-)

Fair enough.  :-)

> Should these changes go through Andrew Morton?  Or can you take them?

I already have a tree set up for workqueue changes, so I guess I can
take them.

Thanks.

-- 
tejun
