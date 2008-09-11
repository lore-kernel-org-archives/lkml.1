Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYIKNYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYIKNYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYIKNYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:24:00 -0400
Received: from mga07.intel.com ([143.182.124.22]:40482 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbYIKNX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:23:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,379,1217833200"; 
   d="scan'208";a="44981521"
Message-ID: <48C91BE4.7000602@linux.intel.com>
Date: Thu, 11 Sep 2008 06:23:48 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops/Warning report for the week of September 10th, 2008
References: <48C81D20.9040302@linux.intel.com> <20080911045255.GD6863@suse.de>
In-Reply-To: <20080911045255.GD6863@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Sep 10, 2008 at 12:16:48PM -0700, Arjan van de Ven wrote:
>> Rank 2: sysfs_add_one (warning)
>> 	Reported 215 times (3751 total reports)
>> 	Duplicate sysfs registration; mostly in USB audio
>> 	This warning was last seen in version 2.6.27-rc5, and first seen in 
>> 2.6.24-rc6.
>> 	More info: http://www.kerneloops.org/searchweek.php?search=sysfs_add_one
> 
> This one is going to be a bit tough to track over time as it is the low
> level sysfs code complaining that a user of it is doing something wrong.
> So you can get all sorts of different callers causing the same warning,
> we just have to look at the backtrace to get a hint of who is causing
> the problem.
> 
> Is there any way to break this one down further by caller so we can try
> to narrow it down?  I thought you did that for other types of warnings
> in the past (may_sleep(), etc.)
> 

it's.. a harder one than that.
All the cases so far were "if it's <this function> for <this class>, go one
down in the stacktrace", which I've done table driven.

For sysfs_add_one() it seems to be "if it is sysfs_add_one, dive into the
stacktrace to pick the one below device_add except if that is device_register
or device_create, because then you pick the one below that instead"

Not impossible, just going to take me more than the 3 minutes it normally takes ;-)

(but please correct me if my description of the heuristic is wrong)
