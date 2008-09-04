Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYIDUCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYIDUCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYIDUCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:02:35 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:20830 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYIDUCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:02:34 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Date: Thu, 4 Sep 2008 20:01:31 +0000
Subject: RE: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Thread-Topic: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Thread-Index: AckOyHEvIKNesu3ETu2iwaf49Xd5ygAABfkQ
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com>
 <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com>
 <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org>
 <20080904172052.GN3400@redhat.com>
 <20080904175231.GH18288@one.firstfloor.org>
 <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com>
 <20080904200032.GM18288@one.firstfloor.org>
In-Reply-To: <20080904200032.GM18288@one.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly.

The hpwdt driver is meant to be a catch-all for any NMI coming through on ProLiant HW only. Moreover, for newer ProLiant HW at that.

Once the NMI comes in, we call into our BIOS for the true reason of the NMI. That message gets logged to the IML in NVRAM for the user to view. We then panic the system.

Yes, kdump will work under this scenario because we stop the watchdog timer. This is a user configurable setting.


Tom

-----Original Message-----
From: Andi Kleen [mailto:andi@firstfloor.org]
Sent: Thursday, September 04, 2008 3:01 PM
To: Vivek Goyal
Cc: Don Zickus; Andi Kleen; Ingo Molnar; Prarit Bhargava; Peter Zijlstra; linux-kernel@vger.kernel.org; arozansk@redhat.com; Mingarelli, Thomas; ak@linux.intel.com; Alan Cox; H. Peter Anvin; Thomas Gleixner; Maciej W. Rozycki
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback

> Add "kdump" to the list. It will also be broken if we decide to let one
> driver hijack the NMI handler.

kdump is a special case, similar to the NMI button panic mode. It should
be always only active when the user configured it. When the user configured
it should be always the fallback and override any other drivers.

But watchdog is a special case. I assume the watchdog will just log
(and do the work that a SMI should be doing) but then continue
the chain so that kdump can dump on a watchdog timeout.

-Andi
