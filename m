Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbYFWVI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbYFWVI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYFWVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:08:20 -0400
Received: from ruckus.brouhaha.com ([64.62.206.2]:45005 "EHLO
	ruckus.brouhaha.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYFWVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:08:19 -0400
Message-ID: <57001.64.62.206.10.1214255297.squirrel@ruckus.brouhaha.com>
In-Reply-To: <877iciyjcs.fsf@basil.nowhere.org>
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
    <877iciyjcs.fsf@basil.nowhere.org>
Date: Mon, 23 Jun 2008 14:08:17 -0700 (PDT)
Subject: Re: Any lightweight way for one thread to force another thread to  
     suspend execution?
From: "Eric Smith" <eric@brouhaha.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote about my inquire regarding a way to synchronously stop
another thread:
> Any such mechanism will need a syscall, and it's unlikely that
> any syscall will get much cheaper than a kill(SIGSTOP)

Unfortunately, as Bart pointed out, this stops ALL the threads
in a process (required for POSIX conformance).  However, it appears that
I may be able to do it by creating my threads using clone() with appropriate
parameters rather than pthread_create().

The next question, which I haven't yet been able to answer for myself
from staring at the kernel sources, is whether sending SIGSTOP is
synchronous.  In other words, when the kill() returns, is the target
thread already stopped?  Even on an SMP system where the thread may have
been executing concurrently on another processor?

If not, the next question will be whether there's a more efficient way
to wait for a process to enter the "T" state than busy-polling a file
in /proc.

Thanks,
Eric

