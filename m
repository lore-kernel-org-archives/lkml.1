Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYJ1J56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYJ1J56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYJ1J5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:57:48 -0400
Received: from hera.cwi.nl ([192.16.191.8]:43670 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYJ1J5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:57:47 -0400
X-Greylist: delayed 2444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 05:57:47 EDT
Date: Tue, 28 Oct 2008 10:11:48 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: mtk.manpages@gmail.com
Cc: Daniel Gollub <dgollub@suse.de>, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, linux-man@vger.kernel.org,
       ltp-list@lists.sourceforge.net, "A.E. Brouwer" <aeb@win.tue.nl>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Message-ID: <20081027204509.GA27111@ub>
References: <20081023145054.998439866@marvin.suse.de> <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 05:53:25PM -0500, Michael Kerrisk wrote:

> Hi Daniel,
> 
> On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub@suse.de> wrote:
>>
>> found something which looks for me like a kernel/glibc syscall mismatch.
>>
>> The standard and the manpages and glibc have
>> ssize_t readlink(..., size_t bufsize);
>>
>> But the kernel has
>>
>> linux-2.6/include/linux/syscalls.h:
>> asmlinkage long sys_readlink(..., int bufsiz);
>>
>> All readlink prototypes, expect the one in the kernel, have an unsigned
>> buffer size.
> 
> I agree; the inconsistency is strange.

Hmm. I am inclined not to agree. There is no reason to expect
any particular relation between the kernel prototype of sys_foo
(if such a function exists)
and the user space prototype of the foo() C-library function.

The POSIX standard, man-pages, libc include files document the
userspace / libc interface, not the system call interface.
The system call interface is mostly undocumented.

The kernel prototype is chosen for kernel-internal or historical reasons.

Andries


sys_ppc32.c:
/* Note: it is necessary to treat bufsiz as an unsigned int ... */
asmlinkage long compat_sys_readlink(..., u32 bufsiz)

