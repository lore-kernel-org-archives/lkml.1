Return-Path: <linux-kernel-owner+w=401wt.eu-S934687AbXG3O0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687AbXG3O0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762653AbXG3O0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:26:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59574 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762646AbXG3O0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:26:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] i386 relocable kernel breakes /proc/kcore debugging
References: <200707280443.44048.maximlevitsky@gmail.com>
	<20070730080303.GA6071@in.ibm.com>
	<20070730084116.GA18263@host0.dyn.jankratochvil.net>
Date: Mon, 30 Jul 2007 08:23:11 -0600
In-Reply-To: <20070730084116.GA18263@host0.dyn.jankratochvil.net> (Jan
	Kratochvil's message of "Mon, 30 Jul 2007 10:41:16 +0200")
Message-ID: <m11weqvuls.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kratochvil <jan.kratochvil@redhat.com> writes:

> On Mon, 30 Jul 2007 10:03:03 +0200, Vivek Goyal wrote:
>> On Sat, Jul 28, 2007 at 04:43:43AM +0300, Maxim Levitsky wrote:
> ...
>> > gdb 'thinks' that all kernel symbols are below 0x80000000 , while they are
> at
>> > 0xC000....
>> > 
>> > Turning CONFIG_RELOCATABLE off fixes that, so I assume that is the reason
> for
>> > that.
>> 
>> This is a gdb issue. I had raised it in gdb mailing list some time back.
>> 
>> http://sourceware.org/ml/gdb/2006-08/msg00137.html
>
> There was the patch post:
> 	http://sources.redhat.com/ml/gdb/2006-08/msg00182.html
>
>> What version of gdb you are using? I know it got fixed for gdb shipped
>> with RHEL5. I am not sure about what upstream version of gdb it got fixed
>> in.
>
> It did not make it to the upstream as the patch above is an imperfect one.
> It is fixed in RH gdb-6.5-5 upwards, therefore Fedora 6 + RHEL-5.
> 	http://cvs.fedora.redhat.com/viewcvs/*checkout*/devel/gdb/gdb-6.5-bz203661-emit-relocs.patch?root=core

Has anyone looked at the filtering by ignoring SHTSYM_TAB?  The other
approach suggested?  The patch above only works for ET_EXEC because
we can safely ignore everything.

Eric
