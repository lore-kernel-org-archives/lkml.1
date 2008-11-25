Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYKYJIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYKYJIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYKYJId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:08:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYKYJIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:08:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: Regression: ACPI AC driver doesn't work on Toshiba Portege R500 (bisected)
Date: Tue, 25 Nov 2008 10:08:16 +0100
User-Agent: KMail/1.9.9
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       walken <walken@zoy.org>
References: <200811230053.14211.rjw@sisk.pl> <200811241430.02434.rjw@sisk.pl> <1227576257.4021.16.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1227576257.4021.16.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251008.16523.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of November 2008, Zhao Yakui wrote:
> On Mon, 2008-11-24 at 21:30 +0800, Rafael J. Wysocki wrote: 
> > On Monday, 24 of November 2008, Zhang Rui wrote:
> > > On Mon, 2008-11-24 at 09:21 +0800, Rafael J. Wysocki wrote:
> > > > On Monday, 24 of November 2008, Zhao Yakui wrote:
> > > > > On Mon, 2008-11-24 at 07:37 +0800, Rafael J. Wysocki wrote:
> > > > > > On Sunday, 23 of November 2008, Rafael J. Wysocki wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > With current mainline (2.6.28-rc6-git1 as of today) on Toshiba Portege R500 the
> > > > > > > status of the AC adapter is not updated when the adapter is unplugged and
> > > > > > > plugged in.  Evidently, /sys/class/power_supply/ADP1/online always contains the
> > > > > > > same value.  Interestingly enough, though, if the box is suspended to RAM and
> > > > > > > resumed, the status of the AC adapter is correctly updated, but the value read
> > > > > > > at that time remains in /sys/class/power_supply/ADP1/online until the next
> > > > > > > suspend/resume cycle regardless of what's going on with the AC adapter.
> > > > > > > 
> > > > > > > 2.6.27.7 works correctly on this box so the recent EC patches don't seem to
> > > > > > > cause this regression to happen.
> > > > > > > 
> > > > > > > Any other ideas?
> > > > > Hi, Rafael
> > > > >     Will you please open a new bug at
> > > > > http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI and attach the
> > > > > output of acpidump, dmesg, lspci -vxxx?
> > > > >     If no ACPI event is reported when AC adapter is unplugged and
> > > > > plugged, the /sys/class interface can't display the correct AC status.
> > > > > Now Rui is working on this issue and the patch is already finished. But
> > > > > it is not sent to Lenb.
> > > > 
> > > > Can you give me a link to the patch, please?
> > 
> > Thanks.
> > 
> > Still, it doesn't seem to be related to the problem at hand.
> On the R500 box there exist two issues related with AC driver
>     a. no ACPI event is reported by AC adapter. The root cause is that
> the GPE is shared by several devices(Fake Power button, LID device,HS86,
> HS87, ADP1). If the GPE is registered as run_wake type by the fake power
> button, the AC adapter can be reported correctly. If the GPE is
> registered as wake type, the AC adapter can't be reported correctly.
>     In the commit the GPE obtained from the _PRW packge of Power button
> device won't be registered as the Fix power button is used instead of
> generic power button.
>     b. the /sys/class/power_supply/ADP1/online can't report the correct
> status of AC adapter.But the /proc/acpi/ interface can report the
> correct status even when there is no ACPI event. This can be fixed by
> the patch from Rui. 

I see, thanks for the explanation.

The /proc/acpi interface is not compiled in here, so obviously I didn't notice
the issue with it.

Thanks,
Rafael
