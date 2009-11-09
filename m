Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZKIJbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZKIJbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZKIJbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:31:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZKIJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:31:21 -0500
To: Mark Veltzer <mark.veltzer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: get_user_pages question
From: Andi Kleen <andi@firstfloor.org>
References: <200911090850.26724.mark.veltzer@gmail.com>
Date: Mon, 09 Nov 2009 10:31:26 +0100
In-Reply-To: <200911090850.26724.mark.veltzer@gmail.com> (Mark Veltzer's message of "Mon, 9 Nov 2009 08:50:25 +0200")
Message-ID: <87skco59jl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Veltzer <mark.veltzer@gmail.com> writes:
>
> I am testing this kernel module with several buffers from user space allocated 
> in several different ways. heap, data segment, static variable in function and 
> stack. All scenarious work EXCEPT the stack one. When passing the stack buffer 
> the kernel sees one thing while user space sees another.

In theory it should work, stack is no different from any other pages.
First thought was that you used some platform with incoherent caches,
but that doesn't seem to be the case if it's standard x86.

> My not so intelligent questions (they may well be off the mark):
> - How can this be? (two views of the same page)

It should not be on a coherent platform.

> - Does not 'get_user_pages' pin the pages?

Yes it does.

> - Could this be due to stack protection of some sort?

No.

> - Do I need to do anything extra with the vm_area I receive for the stack 
> pages EXCEPT 'get_user_pages' ?

No. Stack is like any other user memory.

Most likely it's some bug in your code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
