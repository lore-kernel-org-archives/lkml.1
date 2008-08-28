Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYH1RCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYH1RCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYH1RBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:01:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:47943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYH1RBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:01:52 -0400
Message-ID: <48B6D9B7.2050406@kernel.org>
Date: Thu, 28 Aug 2008 19:00:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org> <20080828164924.GB17475@kroah.com>
In-Reply-To: <20080828164924.GB17475@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:01:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 28, 2008 at 06:31:02PM +0200, Tejun Heo wrote:
>> add_uevent_var() appends the specified variable whether the new entry
>> has duplicate key or not.  This patch makes add_uevent_var() to
>> override the existing entry if an entry with the same key is added
>> later.  This will be used by CUSE (character device in userland) to
>> fake hotplug events.
> 
> Hm, do you have any pointers to CUSE, that sounds interesting.

I'm in the process of sending patches.  I'll cc you on the actual postings.

> And how would this change interact with fake hotplug events?

CUSE creates actual devices but those devices are all cuse class
devices.  To play nicely with sysfs/hal, the ADD/REMOVE uevents should
have about the same variables as the actual device including the
SUBSYSTEM, so that's where the overriding comes in.  CUSE client tells
CUSE that it needs to set such such envs for uevents and CUSE overrides
uevents before sending it out so that sysfs/hal can be fooled.

Thanks.

-- 
tejun
