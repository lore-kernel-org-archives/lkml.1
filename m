Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZFLLKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZFLLKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbZFLLKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:10:23 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57831 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbZFLLKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:10:21 -0400
MIME-Version: 1.0
In-Reply-To: <20090611142700.GA12259@caradoc.them.org>
References: <cc557aab0906100325o4fd55e0eveb958915214809e3@mail.gmail.com>
	 <20090611142700.GA12259@caradoc.them.org>
Date: Fri, 12 Jun 2009 14:10:20 +0300
Message-ID: <cc557aab0906120410h71e3ab59neeaf85c3223fd7c6@mail.gmail.com>
Subject: Re: ERESTART_RESTARTBLOCK and ptrace()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-arm-kernel@lists.arm.linux.org.uk, Nicolas Pitre <nico@cam.org>,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 5:27 PM, Daniel Jacobowitz<dan@debian.org> wrote:
> On Wed, Jun 10, 2009 at 01:25:34PM +0300, Kirill A. Shutemov wrote:
>> I've got bug in handling ERESTART_RESTARTBLOCK. Kernel version is 2.6.28.
>>
>> Steps to reproduce:
>> 1. Attach using ptrace() to process while it's in a syscall which use
>> ERESTART_RESTARTBLOCK
>> on interrupt. The easiest way is to attach to process which is in nanosleep().
>> 2. Run a syscall in context of the process like it does gdb.
>> 3. Continue the process.
>>
>> Results:
>> Syscall(nanosleep) return error code 516(ERESTART_RESTARTBLOCK). It's
>> kernel's internal error
>> code and should never appear at userspace.
>>
>> It seems ARM-related since I can't reproduce it on x86.
>
> That's because GDB has code to do the right thing on x86.  Consider
> filing a GDB bug please.

http://sourceware.org/bugzilla/show_bug.cgi?id=10267
