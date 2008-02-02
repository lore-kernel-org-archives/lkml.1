Return-Path: <linux-kernel-owner+w=401wt.eu-S1762749AbYBBADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762749AbYBBADx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761785AbYBBADp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:03:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:31079 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761580AbYBBADo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:03:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P13C8oSYVDQ24G94R/TOxM1YT56/hQS0PbzIcA03G3/wCmN/6JR+4k6qzNp9j6SWHeZrBqnMSsX66TYtrOsfNCikmpxzk8wDXtacLENxvRi8bBhYsaVdM9whgBvBk0GO2+R5SaTkgrRgweNP9XOaUSyX611NDYMhQ2XpYnmgStQ=
Message-ID: <b647ffbd0802011603t28210b90y8d519585c44da352@mail.gmail.com>
Date: Sat, 2 Feb 2008 01:03:43 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080201232550.GA682@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801280226.22013.rjw@sisk.pl> <200801312154.33754.rjw@sisk.pl>
	 <1201867497.32654.49.camel@lappy>
	 <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com>
	 <20080201171022.GC2159@elte.hu>
	 <b647ffbd0802011354ra2b9494ub59475abad4466aa@mail.gmail.com>
	 <b647ffbd0802011444n366c1537m7fb44acf0b848941@mail.gmail.com>
	 <20080201224852.GA16700@elte.hu>
	 <b647ffbd0802011522y3d4d779ambaf1a21f368ef74a@mail.gmail.com>
	 <20080201232550.GA682@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2008, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
> > yeah, I was already on a half-way to check it out.
> >
> > It does fix a problem for me.
> >
> > Don't forget to take along these 2 fixes from Peter's patch:
> >
> > - fix break usage in do_each_thread() { } while_each_thread().
> > - fix the hotplug switch stmt, a fall-through case was broken.
>
> Dmitry, i sent Peter's fix(es) below to Linus. Do you concur that it
> fixes all the practical and theoretical problems you could see with the
> code too?
>

One comment: any argument for waking up the 'watchdog' thread from
softlockup_tick() wrt just having schedule_timeout_interruptible(HZ)
in watchdog() ?
(although, it's not that important).

IMHO, it looks good.

(I'll look again tomorrow when I'm less sleepy :-/)

-- 
Best regards,
Dmitry Adamushko
