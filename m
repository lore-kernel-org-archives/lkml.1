Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbXEMGto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbXEMGto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXEMGth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:49:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36865 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMGth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:49:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	<m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
Date: Sun, 13 May 2007 00:48:53 -0600
In-Reply-To: <86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 12 May 2007 23:29:23 -0700")
Message-ID: <m1abw9qkve.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 5/12/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Overwriting the GDT should be fine because we don't reload the segments,
>> after we overwrite it.  GDT entries are only read when we load segments.
>> Interrupts are disabled so that should not cause a problem.
>>
>> Why do you think the current behaviour is a problem?
>
> just think if GDT should not be overwriten when we are still under
> that GDT setting.
> didn't have chance to test that in HDT or other debug device, when
> setting breaking point after that GDT is overwriten.

It would be interesting to see if you could produce a failure using
that gdt, I don't think you will be able to, even with a debugger.

For data segments we never use that GDT, it is only for the code
segment we use the GDT and that only to get us into 64bit mode.

Eric
