Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbXBVWRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbXBVWRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXBVWRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:17:36 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:43892 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751979AbXBVWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:17:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MidGEpJjrAMM4UYZZav8z+ElfzXp3l+ZbHjXGmw90zNhpOSp/N1l0DxDcr/+LKbu3PxxIQMgeRfMhktqiZJtp5STe9W0Q1vbxDo5JTwXbPiRmLHOmkQCF+2nDhtM4GjT5dchp/XUTmZLobVqnfHOBXUj1K99LpqXEnT0SOZAJtU=  ;
X-YMail-OSG: Nyfw070VM1lJq0RpTCFLGRau3bdywMBvMwZ89JRKzBkcK2_6NKM3hbvHHOBJO8Zz0F0jhQpAthWnAIDvyZXydOZAtU2E6B9lV83OUu.H_jqENzQyQHTLGcdgiIVGELPmUr_pELETBKdtXhY-
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.20-mm2
Date: Thu, 22 Feb 2007 14:17:31 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702211957.00930.david-b@pacbell.net> <200702220933.37559.rjw@sisk.pl>
In-Reply-To: <200702220933.37559.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221417.32626.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 12:33 am, Rafael J. Wysocki wrote:

> Unfortunately, the userland shipped with OpenSUSE refuses to talk to the new
> one (or I don't know how to make it do that).

Did your "udev" create a /dev/rtc0?  If not, /sys/class/rtc-dev/rtc0/dev
will give the right major/minor numbers.

Given a /dev/rtc0, there are two simple solutions:

  (a) ln -s /dev/rtc0 /dev/rtc
  (b) upgrade your "hwclock" to one supporting "hwclock --file /dev/rtc0",
      since that should also try rtc0 when rtc can't be opened.

I found a udev incantation "git whatchanged drivers/rtc/rtc-dev.c",
which can automate (a):

       KERNEL=="rtc0", SYMLINK+="rtc"

I'm not sure what the story is on hwclock updates, given the issue
with "util-linux" maintainership.  I sent a patch on 7-Aug-2006 to
Adrian Bunk, which appears to have been disregarded, then to Karel
Zak (for the new fork?) on 17-Nov-2006 ... but if there's been an
announcement about a new util-linux repository with that patch,
I missed it.  The busybox patch I submitted 26-Jan-2007 hasn't
yet been merged, but that's a lot more understandable.

Basically it looks like userspace is almost a year behind the kernel
support for this RTC framework.  The problematic part is that it
seems that the "util-linux" maintainership issues are preventing
that issue from getting resolved ... so for now, I usually use
workaround (a).


> > Shoot.  OK, I'll see if I can reproduce it myself.  Is this system
> > using a generic CMOS RTC?  Or is HPET somehow involved?  (That old
> > RTC driver has HPET voodoo as well as normal RTC stuff.)
> 
> How can I check that?

If your boot messages say things about HPET, that's a start.  :)
I don't really know HPET; it hasn't ever come up on any system
that I've used.  ISTR that for various reasons BIOS would hide
it on most systems, but that Linux has been working on un-hiding
that hardware so it could be used.  I'll read up on it.  (As I
implied, the source code comments leave a lot to be desired.)

- Dave
