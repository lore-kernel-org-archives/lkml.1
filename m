Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab0BQJ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:58:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46401 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab0BQJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:58:41 -0500
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
From: Andi Kleen <andi@firstfloor.org>
References: <201002161520.26700@zigzag.lvk.cs.msu.su>
Date: Wed, 17 Feb 2010 10:58:33 +0100
In-Reply-To: <201002161520.26700@zigzag.lvk.cs.msu.su> (Nikita V. Youshchenko's message of "Tue, 16 Feb 2010 15:20:26 +0300")
Message-ID: <87r5ok5gl2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nikita V. Youshchenko" <yoush@cs.msu.su> writes:

> I'm developing a device driver that, in it's ioctl()s, accepts a complex 
> data structure. Before doing it's operation, it performs large number of 
> checks if data is valid. If one of those checks fail, driver 
> returns -EINVAL.
>
> Unfortunately this -EINVAL is not really useful. E.g. if a developer, 
> sitting in his IDE and debugging his code, will see ioctl() 
> returning -EINVAL, and will have hard times finding what exactly is wrong.
>
> Before inventing driver-specific extended error reporting, I'd like to ask 
> if there is anything more or less generic for this.
> I believe situation when -Exxx is too weak interface for error reporting is 
> common.

This is a very common problem in Linux unfortunately.  I always
describe that as a the "ed approach to error handling". Instead
of giving a error message you just give ?. Just ? happens
to be EINVAL in Linux. 

My favourite example of this is the configuration of the networking
queueing disciplines, which configure complicated data structures and
algorithms and in many cases have tens of different error conditions
based on the input parameters -- and they all just report EINVAL.

The standard way (standard kludge or standard workaround would be a
better description) is to use printk; often guarded by a special
kernel tunable or ifdef to avoid flooding the log in the normal case.

IMHO it would be best to simply add a way to return strings directly
in this case (a la plan9). This would be probably not too hard to
implement. It's not there unfortunately.

This could be done with one of the message oriented protocols,
e.g. netlink or read/write on a special minor.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
