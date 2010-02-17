Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab0BQKQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:16:56 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:37354 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab0BQKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:16:54 -0500
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Extended error reporting to user space?
Date: Wed, 17 Feb 2010 13:16:48 +0300
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <87r5ok5gl2.fsf@basil.nowhere.org>
In-Reply-To: <87r5ok5gl2.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002171316.49165@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "Nikita V. Youshchenko" <yoush@cs.msu.su> writes:
> > I'm developing a device driver that, in it's ioctl()s, accepts a
> > complex data structure. Before doing it's operation, it performs large
> > number of checks if data is valid. If one of those checks fail, driver
> > returns -EINVAL.
> >
> > Unfortunately this -EINVAL is not really useful. E.g. if a developer,
> > sitting in his IDE and debugging his code, will see ioctl()
> > returning -EINVAL, and will have hard times finding what exactly is
> > wrong.
> >
> > Before inventing driver-specific extended error reporting, I'd like to
> > ask if there is anything more or less generic for this.
> > I believe situation when -Exxx is too weak interface for error
> > reporting is common.
>
> This is a very common problem in Linux unfortunately.  I always
> describe that as a the "ed approach to error handling". Instead
> of giving a error message you just give ?. Just ? happens
> to be EINVAL in Linux.
>
> My favourite example of this is the configuration of the networking
> queueing disciplines, which configure complicated data structures and
> algorithms and in many cases have tens of different error conditions
> based on the input parameters -- and they all just report EINVAL.
>
> The standard way (standard kludge or standard workaround would be a
> better description) is to use printk; often guarded by a special
> kernel tunable or ifdef to avoid flooding the log in the normal case.
>
> IMHO it would be best to simply add a way to return strings directly
> in this case (a la plan9). This would be probably not too hard to
> implement. It's not there unfortunately.
>
> This could be done with one of the message oriented protocols,
> e.g. netlink or read/write on a special minor.

Why not create a generic solution for this, if one does not exist yet?

For example, have a "last error" string associated with task_struct, that:
- will clean on each syscall entry,
- while syscall is running, may be filled with printf-style routines,
- may be accessible from userspace with additional syscall [that obviously 
should not reset error]?

This will give driver writers a common interface for extended error 
reporting...

Nikita
