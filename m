Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYFQJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYFQJbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYFQJbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:31:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYFQJbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:31:42 -0400
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: "fb-defio: fix page list with concurrent processes"
References: <4856E38E.1040203@goop.org>
	<45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
	<874p7so6p7.fsf@pike.pond.sub.org>
	<45a44e480806170121s222906cdt23db2d6c394a50a1@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Tue, 17 Jun 2008 11:31:35 +0200
In-Reply-To: <45a44e480806170121s222906cdt23db2d6c394a50a1@mail.gmail.com> (Jaya Kumar's message of "Tue\, 17 Jun 2008 01\:21\:13 -0700")
Message-ID: <87hcbsmmq0.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Tue, Jun 17, 2008 at 12:34 AM, Markus Armbruster <armbru@redhat.com> wrote:
>> "Jaya Kumar" <jayakumar.lkml@gmail.com> writes:
>>
>>> On Mon, Jun 16, 2008 at 3:05 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>> Your patch "fb-defio: fix page list with concurrent processes" definitely
>>>> seems to help with the suspend/resume problem I had with the Xen pvfb
>>>> device.  Is it queued up anywhere?  It seems to be a real bugfix, and should
>>>> probably be queued for 2.6.26...
>>>
>>> It isn't currently queued. I had intended to improve its performance
>>> by taking advantage of Andrew's suggestion of using !list_empty on the
>>> page->lru to avoid walking the page list to find the duplicate page,
>>> but I ran into trouble since the page starts off being on the lru
>>> list. I'll try to take a look at doing this next weekend.
>>>
>>> Thanks,
>>> jaya
>>
>> Well, we got a bug that makes the code useless in practice for us, and
>> a fix for it that's not quite as fast as it could be.  Which is
>> better, somewhat slow code, or somewhat useless code?  I'd like to see
>> the fix merged as soon as possible.  You can always improve its
>> performance later.
>>
>
> Ok, I didn't realize there was any time pressure. Keep in mind, I'm
> just a person doing this stuff for fun on weekends not someone under
> commercial pressures. Yup, I've got no problem if the old patch is
> requeued and merged.
>
> Thanks,
> jaya

Hey, it's your own fault!  If you wrote useless code in your spare
time, we wouldn't bother you ;->

Seriously, I appreciate your contributions, and I didn't mean to
pressure you.  Just to explain why I think it makes sense to merge
your fix now, and performance improvements later.
