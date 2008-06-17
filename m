Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYFQHfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYFQHfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 03:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYFQHeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 03:34:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYFQHet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 03:34:49 -0400
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: "fb-defio: fix page list with concurrent processes"
References: <4856E38E.1040203@goop.org>
	<45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Tue, 17 Jun 2008 09:34:44 +0200
In-Reply-To: <45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com> (Jaya Kumar's message of "Mon\, 16 Jun 2008 18\:11\:14 -0700")
Message-ID: <874p7so6p7.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Mon, Jun 16, 2008 at 3:05 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Your patch "fb-defio: fix page list with concurrent processes" definitely
>> seems to help with the suspend/resume problem I had with the Xen pvfb
>> device.  Is it queued up anywhere?  It seems to be a real bugfix, and should
>> probably be queued for 2.6.26...
>
> It isn't currently queued. I had intended to improve its performance
> by taking advantage of Andrew's suggestion of using !list_empty on the
> page->lru to avoid walking the page list to find the duplicate page,
> but I ran into trouble since the page starts off being on the lru
> list. I'll try to take a look at doing this next weekend.
>
> Thanks,
> jaya

Well, we got a bug that makes the code useless in practice for us, and
a fix for it that's not quite as fast as it could be.  Which is
better, somewhat slow code, or somewhat useless code?  I'd like to see
the fix merged as soon as possible.  You can always improve its
performance later.
