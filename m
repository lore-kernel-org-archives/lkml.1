Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZJFPzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZJFPzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbZJFPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:55:04 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:39214 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZJFPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:55:03 -0400
Message-ID: <4ACB6830.7050004@anirban.org>
Date: Tue, 06 Oct 2009 08:54:24 -0700
From: Anirban Sinha <ani@anirban.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, ani@anirban.org,
       asinha@zeugmasystems.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] futex: Nullify robust lists after cleanup
References: <new-submission> <tip-fc6b177dee33365ccb29fe6d2092223cf8d679f9@git.kernel.org>
In-Reply-To: <tip-fc6b177dee33365ccb29fe6d2092223cf8d679f9@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Once upon a time, like on 09-10-06 8:03 AM, tip-bot for Peter Zijlstra wrote:

> futex: Nullify robust lists after cleanup
> 
> The robust list pointers of user space held futexes are kept intact
> over an exec() call. When the exec'ed task exits exit_robust_list() is
> called with the stale pointer. The risk of corruption is minimal, but
> still it is incorrect to keep the pointers valid. Actually glibc
> should uninstall the robust list before calling exec() but we have to
> deal with it anyway.
> 
> Nullify the pointers after [compat_]exit_robust_list() has been
> called.
> 
> Reported-by: Anirban Sinha <ani@anirban.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> LKML-Reference: <new-submission>
> Cc: stable@kernel.org

Excellent! I very much like the solution because:

(a)  it reiterates the fact that an execve() call is indeed logically the
'death' of a process.
'(b) cleans up state that should not logically propagate across an execve() call.
(c) Does not introduce new EWOULDBLOCK semantics that can potentially break user
land.
(d) Restores the 'robust' behavior of futexes by waking up other processes
waiting on it on an exec() call.
(e) handles potentially broken/buggy applications gracefully.
(f) as far as I can see, the world would be better and no worse with this patch :)

I'll let you guys know if something else strikes my eyes as being odd in the
course of my digging through the code.

Ani

