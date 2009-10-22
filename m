Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZJVTMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZJVTMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZJVTMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:12:25 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44803 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbZJVTMY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:12:24 -0400
From: Bela Lubkin <blubkin@vmware.com>
To: "'Matt Domsch'" <Matt_Domsch@dell.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Corey Minyard <minyard@acm.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Date: Thu, 22 Oct 2009 12:12:42 -0700
Subject: RE: [Openipmi-developer] [Discuss] [PATCH] ipmi: use round_jiffies
	on timers to reduce timer overhead/wakeups
Thread-Topic: [Openipmi-developer] [Discuss] [PATCH] ipmi: use round_jiffies
	on timers to reduce timer overhead/wakeups
Thread-Index: AcpSx3xGEkG1GjydT6i3pbX/xv/paQAfSEYw
Message-ID: <E0AA796A7E3F4C4E8F1065D15FE4786183AF6948@EXCH-MBX-4.vmware.com>
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
	<20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com>
	<20091021130348.cd521b0c.randy.dunlap@oracle.com>	<4ADF6D76.7070409@acm.org>
 <4ADF75A2.50202@linux.intel.com>
 <20091022025013.GB20467@auslistsprd01.us.dell.com>
In-Reply-To: <20091022025013.GB20467@auslistsprd01.us.dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:

> Though I'm really curious that HP has a KCS+interrupt controller
> available.  That gives me hope that the industry-wide problems which
> prevented Dell from doing likewise a couple years ago are now
> resolved.  I'll have my team look into it again.

Can you expand on "industry-wide problems"?  (Forced to share
interrupts with a high rate device?  Design your gizmo to
support MSI/MSI-x.  Add MSI support to ipmi_si if necessary...)

As far as I can tell, HP has never shipped an interrupt-less
BMC.  Their current iLO2 BMC is KCS + interrupt.  Their older
design was SMIC + interrupt.

Why does everyone use KCS when BT is obviously better?  Can
you have your team look into that as well?  (Among the various
goals here, I assume that BT -- with a single interrupt and a
DMA transfer instead of shuffling bytes over I/O ports -- would
cost less power.  Not that the members of that list will
receive this message: it bounces nonmembers.)

It appears that BT designs usually include both BT & KCS
programming interfaces to the same BMC.  So perhaps there is
some increased silicon complexity -- but c'mon, we're talking
about a couple of silicon library macros here.

Also, I see evidence of some Sun BMCs that have BT without KCS,
so apparently it isn't required to pair them.  Pairing is
probably done for the benefit of certain dumb client software
that assumes all BMCs are KCS.  I say to heck with that SW.
Any app running under an OS that provides an adequate driver
[which includes at least Linux, Solaris, and -- I assume --
Win] shouldn't be thinking about the BMC programming
interface at all.

>Bela<