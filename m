Return-Path: <linux-kernel-owner+w=401wt.eu-S1422955AbXCOQ3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422955AbXCOQ3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422948AbXCOQ3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:29:07 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48585 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422955AbXCOQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:29:06 -0400
X-AuditID: d80ac287-9f7d7bb000000de9-04-45f974519ae7 
Date: Thu, 15 Mar 2007 16:29:02 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Alan Stern <stern@rowland.harvard.edu>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       gregkh@suse.de, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.44L0.0703150953420.13086-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0703151555240.26565@blonde.wat.veritas.com>
References: <Pine.LNX.4.44L0.0703150953420.13086-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Mar 2007 16:29:04.0513 (UTC) FILETIME=[0BEDCF10:01C7671F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Alan Stern wrote:
> 
> Personally I don't understand what was wrong with my name.  What's weird 
> or unintuitive about doing something in a different task's context?

The only thing wrong with sysfs_do_something_in_a_different_task_context()
is the length of the name.  "do", that's good, much better than "access".

sysfs_access_in_other_task() left me wondering what this "other" task
was, and what kind of "access" it's trying to get - or is the calling
task the other, and it's trying to access something it wouldn't
directly have access to?

> 
> Dmitry's suggestion is slightly inappropriate because the function doesn't
> take a workstruct as an argument and it isn't itself a workqueue callback.  

True, though since he's saying "work" rather than "workstruct",
I was okay with that: it's a sysfs wrapper to schedule_work().

> 
> Would people be happier with sysfs_schedule_callback() and
> device_schedule_callback()?  At least the functions do take a callback 
> pointer as an argument, even though they aren't callbacks themselves.

A lot happier than with sysfs_access_in_other_task() -
if you prefer this to Dmitry's, it's okay by me.

Hugh
