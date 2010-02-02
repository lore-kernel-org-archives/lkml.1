Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0BBERI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:17:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55740 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0BBERD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:17:03 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>, dedekind1@gmail.com,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
	<1264689482.1973.132.camel@localhost>
	<20100129071324.2521705c@marrow.netinsight.se>
	<20100129023327.021cb23d.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Feb 2010 20:16:46 -0800
In-Reply-To: <20100129023327.021cb23d.akpm@linux-foundation.org> (Andrew Morton's message of "Fri\, 29 Jan 2010 02\:33\:27 -0800")
Message-ID: <m1eil4i85t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 29 Jan 2010 07:13:24 +0100 Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
>
>> On Thu, 28 Jan 2010 16:38:02 +0200
>> Artem Bityutskiy <dedekind1@gmail.com> wrote:
>> 
>> > On Wed, 2010-01-27 at 10:53 +0800, Am__rico Wang wrote:
>> > > > Well, it provides a few more ways of crashing the kernel. That's
>> > > > basically the only additional feature you'll get.
>> > > 
>> > > Yeah, I can see that, but why do I need to care how I crash the kernel
>> > > as long as I can crash it in a way.
>> > 
>> > But Simon did explain in his first e-mail why he cares. You or others
>> > might care for similar reasons.
>> 
>> Another argument for the patch is that it's simple and well-contained,
>> it doesn't touch any other code apart from the driver itself.
>> 
>> It is also easy to extend with other tests, e.g., provoking kernel
>> hangs to test watchdogs and so on.
>> 
>
> Yes, it's the sort of thing which lots of people have written
> throw-away ad-hoc versions of.  It probably makes sense to do it once,
> do it right to save people from having to rererereinvent that wheel.
>
> What do others think?

I think it makes sense, and in fact we have already merged one attempt
at doing this generically.  drivers/misc/lkdtm.c

I think Simon's patch adds some additional interesting failure modes.
write_after_free, corrupt_stack_write, unaligned_load_store.

Simon is there any chance you can change your patch to an enhancement of lkdtm?

lkdtm actually digs into the interesting failure points with a jprobe
to trigger the harder to reproduce scenarios.  Like stack overflow in
an interrupt handler.

Eric
