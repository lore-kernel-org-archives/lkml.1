Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZGXP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZGXP0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZGXP0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:26:11 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:39437 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZGXP0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AMttnSSiG/3ZrACgUY5Kmxhoe8ZyT8ji2gsCjKtMr4Eqqc6XiZkINBmNa0nWukerEd
         YeVfUy3lT52fKUw6j+sZuWQdnHBcJWPOabFrvXE5QyknAY1VS9NR4SyKP5JHuMP9708Q
         z3dJNm11o+JXkbdrZVhjPLYZh0qm9wAV33RBs=
MIME-Version: 1.0
In-Reply-To: <20090724133903.GA18827@khazad-dum.debian.net>
References: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> 
	<20090723195114.GR28158@elf.ucw.cz> <20090723201050.GD19369@khazad-dum.debian.net> 
	<200907232328.03566.rjw@sisk.pl> <1248396826.3556.26.camel@localhost.localdomain> 
	<20090724133903.GA18827@khazad-dum.debian.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 24 Jul 2009 08:25:49 -0700
Message-ID: <43e72e890907240825l2181297ejb4e1b55ff5e811ef@mail.gmail.com>
Subject: Re: Generic events for wake up from S1-S4
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ykzhao <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 6:39 AM, Henrique de Moraes
Holschuh<hmh@hmh.eng.br> wrote:
> On Fri, 24 Jul 2009, ykzhao wrote:
>> > > Well, we *already* deliver "lid opened" when the lid is opened, regardless
>> > > of it waking up the computer or not.  But we are missing a way to deliver
>> > > other classes of wakeup events.
>> > >
>> > > I know of at least these (incomplete list):
>> > >
>> > > 1. network-initiated wakeup
>> > >    a. wired
>> > >    b. wireless
>> > >    c. long-range wireless
>> > >
>> > > 2. platform health/condition alarms
>> > >    a. battery alarm (two levels, warning and emergency)
>> > >    b. thermal alarm (two levels, warning and emergency)
>> > >    (we need these as generic alarms, not just reason-for-wakeup)
>> > >
>> > > 3. device (or device tree) hotplug/hotunplug
>> > >    a. hotunplug request or notification
>> > >       (we deliver the request/notification, but we don't know we should
>> > >       go back to sleep, so all we are missing is the reason-for-wakeup
>> > >       event)
>> > >
>> > > 4. management
>> > >    a. wake-up/power on clock
>> > >    b. remote management command (IMPI, etc)
>> > >    c. intrusion alarm
>> > >    d. theft alarm
>> > >
>> > > None of those have a standard interface to notify userspace of the reason of
>> > > the wake up AFAIK.  Many of these want a generic event interface to be
>> > > delivered not just as reason-for-wakeup, but also as runtime events.
>> > >
>> > > And I guess we should also tell userspace what state we are waking up from
>> > > (S5 clean state, S5/S4 hibernation, S3), sometimes it matters.
>> >
>> > Agreed, and same for the above.
>> >
>> > So, what in your opinion would be the best way to expose this information?
>
> Frankly?  It needs to be an easy-to-extend ABI, and the only one that cames
> to mind right now are uevents.

That sounds like a great idea.

  Luis
