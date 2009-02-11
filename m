Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZBKHmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZBKHmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZBKHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:41:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:46122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZBKHl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:41:57 -0500
Message-ID: <4992812B.1050800@kernel.org>
Date: Wed, 11 Feb 2009 16:41:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com>
In-Reply-To: <1234277507-4987-3-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 07:41:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
> Some syscalls need to access the pt_regs structure, either to copy
> user register state or to modifiy it.  This patch adds stubs to load
> the address of the pt_regs struct into the %eax register, and changes
> the syscalls to regparm(1) to receive the pt_regs pointer as the
> first argument.

Heh... neat.  Just one question.

> -asmlinkage long sys_iopl(unsigned long regsp)
> +ptregscall long sys_iopl(struct pt_regs *regs, unsigned int level)
>  {
> -	struct pt_regs *regs = (struct pt_regs *)&regsp;
> -	unsigned int level = regs->bx;

Here and at other places where the function takes more than one
arguments, wouldn't it be better to just take *regs and use other
parameters from regs?  That way we won't have to worry about gcc
corrupting register frame at all and I think it's cleaner that way.

Thanks.

-- 
tejun
