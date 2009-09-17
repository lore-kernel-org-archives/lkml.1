Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbZIQMyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbZIQMyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZIQMyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:54:04 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:39138 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZIQMyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:54:03 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make safe some helpers building on container_of
References: <20090914082700.8550.94087.stgit@szonett.ki.iif.hu>
	<20090916224157.cfa621c4.akpm@linux-foundation.org>
Date: Thu, 17 Sep 2009 14:53:58 +0200
In-Reply-To: <20090916224157.cfa621c4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 16 Sep 2009 22:41:57 -0700")
Message-ID: <87ab0tybo9.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 14 Sep 2009 10:27:00 +0200 Ferenc Wagner <wferi@niif.hu> wrote:
>
>> For example, drivers/base/core.c contains
>> 
>> #define to_root_device(dev) container_of(dev, struct root_device, dev)
>> 
>> which works fine as long as the 'to_root_device' macro is always
>> applied to a variable called 'dev', as it is the case in the current
>> kernel sources.  However, it breaks as soon as it gets applied to a
>> variable of any other name, as the name of the variable is also
>> substituted into the third argument of the 'container_of' macro, which
>> really should stay 'dev' in the above case.
>> 
>> This patch renames the real macro arguments in all 5 such constructs
>> found by git-grep -E '#define.*container_of *\( *([^ ,]+) *,.*, *\1 *\)',
>> which may have missed some similar dangerous constructs, of course.
>> So these changes probably cross all possible boundaries of responsibility,
>> and I do not know how to best handle it, suggestions welcome.
>> 
>> Btw. this dangerous idom is also popularised by the excellent Linux Device
>> Drivers book (3rd edition, chapter 14, bottom of page 383).
>> 
>> ...
>>
>> -#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
>> +#define EVT_TO_HPET_DEV(evtdev) container_of(evtdev, struct hpet_dev, evt)
>
> There is no reason whatsoever for implementing these things as macros
> and for the life of me I don't understand why people do this.
>
> If we're going to fix these things then how about we turn them into
> C functions thereby making them even safer?
>
> y:/usr/src/linux-2.6.31> grep -r 'define.*container_of' . | wc -l
> 347

Quite a bunch, but if deemed useful and acceptable, I'm willing to
convert them into static (inline?) functions as a means of thanking
the kernel developer community.  But that surely wouldn't fly as a
single patch.
-- 
Feri.
