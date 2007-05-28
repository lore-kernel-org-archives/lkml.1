Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbXE1VJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbXE1VJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762104AbXE1VJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:09:03 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:42629 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752465AbXE1VJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:09:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=22QZks7UV7JMgFe/Ab8kPzOM5KnuDA138ErIFDtCQLn1bGS09i3Q4qOE7d/SHq80tSocRB4n4Qwq5PZF9RSN4Z14SqweH+CrN2hEf95f9dxtz8ckiKr/Y79q7kg1UGYWiEeu4jWwjTHqlzYVmR4pIsSEQCAjSEcV63//9yL53/Y=  ;
X-YMail-OSG: B_zw80YVM1kvJaVEHn6Qsn468aNZGyFOTgC2GAazkQ35o3c6bQEXpquyY8qijvAv8u4VsTlpPt.g.eE0rj_3voXGCMMI6Dds.8e5mWldLG6ffa9.cGzSqOuho3vWEQ--
From: David Brownell <david-b@pacbell.net>
To: frank paulsen <frank.paulsen@gmx.net>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Date: Mon, 28 May 2007 14:06:52 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de>
In-Reply-To: <87abvogbdp.fsf@buer.dfakt.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705281406.57396.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007, frank paulsen wrote:
> David Brownell <david-b@pacbell.net> writes:
> 
> > On Sunday 27 May 2007, Matthew Garrett wrote:
> >> f5f72b46c349fefcfd4421b2213c6ffb324c5e56 appears to break the userspace 
> >> interface to the CMOS alarm. This could previously be accessed via 
> >> /proc/acpi/alarm ...
> >
> > I was a bit surprised the ACPI team didn't have more comments on
> > that issue, myself.  Thing is, all of /proc/acpi/* is deprecated
> > (scheduled for removal in barely over one month!) and nobody had
> > found any actual users of that "alarm" file when they searched for
> > them a while ago.  I suppose the conclusion then was that there
> > are no applications using it.
> 
> sorry for breaking the CC:, but i am currently not subscribed to lkml.

I restored both lkml and linux-acpi to the CC list.  :)


> please have a look at at http://www.mythtv.org/wiki/index.php/ACPI_Wakeup
> 
> i think there is quite a number of users, but most of them won't ever
> look into LKML :)

That seems to be true.  And those particular users should learn the
portable /sys/class/rtc/rtc0/wakealarm syntax ... e.g. using numeric
seconds-since-epoch ("date '+%s'") instead of strings the kernel needs
to parse.  That way, they can start converting usage sooner.

Someone with edit privs on that wiki should update those docs, and
tell folk to switch to that interface since the other one is going...


I'm suspecting that there should be a CONFIG_ACPI_SLEEP_PROC_ALARM
not the current internal (acpi/sleep/proc.c) HAVE_ACPI_LEGACY_ALARM,
and some way should be found that the two interfaces can coexist for
a while.  But I can't quite make sense of the strategy for getting
rid of the /proc/acpi/* files ... for example, I see one entry
saying the ACPI procfs as a whole vanishes July 2007, and the next
one says that /proc/acpi/button stays until August 2007.

- Dave
 


