Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZKNSv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZKNSv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 13:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZKNSv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 13:51:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZKNSvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 13:51:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [linux-pm] intermittent suspend problem again
Date: Sat, 14 Nov 2009 19:52:49 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc7-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911132059.46377.rjw@sisk.pl> <874ooxho2b.fsf@tac.ki.iif.hu>
In-Reply-To: <874ooxho2b.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911141952.50030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Friday 13 November 2009, Ferenc Wagner wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >>> Yes, echo "core" to /sys/power/pm_test before executing s2disk.
> >> 
> >> It snapshots the system and returns, producing the same console output
> >> as s2ram (is this the expected behaviour?)  I ran this several times in
> >> a loop, and experienced no problems at all.  Maybe it depends on the
> >> amount of memory used...  I saw a freeze saying "99% done" (ie. not
> >> 100%), btw.
> >
> > The number is not always accurate because of rounding errors.  I think we can
> > safely assume that it always happens after the entire image has been written.
> 
> Probably, "done" isn't output otherwise.
> 
> >> Are other pm_test values meaningful with s2disk?  Is this
> >> handled explicitly in s2disk, or does simply the kernel act as if it was
> >> resumed instead of providing the system image after SNAPSHOT_CREATE_IMAGE?
> >
> > The latter.
> 
> Ok, I found the code.  Are other pm_test values meaningful, or possibly
> harmful?

They are supposed to work as for suspend.

> I think I tried freezer, which resulted in a seemingly perfect
> suspend, but the machine didn't try to resume afterwards, but booted
> normally instead...

So this sounds like there's a bug (will check).

> >>> On Wednesday 11 November 2009, Ferenc Wagner wrote:
> >>>
> >>>> I already did the test for STR (see
> >>>> http://bugs.freedesktop.org/show_bug.cgi?id=22126#c3), but will redo
> >>>> with the current kernel tonight.
> >>>
> >>> OK, thanks.
> >> 
> >> No change on this front, FWIW.  But rc7 is out now, I'll test again.
> >
> > Not sure if that's going to work, but yes please test it.
> 
> The KMS related STR freeze (evaluating the _PTS method) is still there.
> I'm continuing testing s2disk with the platform method under rc7 (with
> some instrumentation added).
> 
> Btw, s2ram -f works fine otherwise (no KMS), and my machine is not in
> the whitelist.  I'm not sure whether the KMS problem disqualifies it

No, it doesn't.

> (shall I report it to suspend-devel?),

Yes, please.

> but it can be identified by:
>     sys_vendor   = "IBM"
>     sys_product  = "1834S5G"
>     sys_version  = "ThinkPad R50e"
>     bios_version = "1WET90WW (2.10 )"

Thanks,
Rafael
