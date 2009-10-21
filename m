Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZJUXq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZJUXq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 19:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZJUXq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 19:46:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:43010 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbZJUXq0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 19:46:26 -0400
From: Bela Lubkin <blubkin@vmware.com>
To: "'Corey Minyard'" <minyard@acm.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
CC: "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Date: Wed, 21 Oct 2009 16:46:41 -0700
Subject: RE: [Openipmi-developer] [Discuss] [PATCH] ipmi: use round_jiffies
 on timers to reduce timer overhead/wakeups
Thread-Topic: [Openipmi-developer] [Discuss] [PATCH] ipmi: use round_jiffies
 on timers to reduce timer overhead/wakeups
Thread-Index: AcpSjEuExcQJDzppT7Knairll6LBYwAGu4Jg
Message-ID: <E0AA796A7E3F4C4E8F1065D15FE4786183AF6946@EXCH-MBX-4.vmware.com>
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
	<20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com>
	<20091021130348.cd521b0c.randy.dunlap@oracle.com> <4ADF6D76.7070409@acm.org>
In-Reply-To: <4ADF6D76.7070409@acm.org>
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

Corey Minyard & Randy Dunlap wrote:

Randy>> From what I recall (probably 2 years ago), [older] ipmi hardware
Randy>> does not generate event interrupts, so it has to be polled.
Randy>>
Randy>> Corey, can you elaborate on this?

Corey> Certainly.  Yes, some (probably most) IPMI hardware does not use
Corey> interrupts, and unfortunately, it's not just older machines.
Corey> The driver used to poll more slowly, but in many cases the
Corey> performance was unacceptable.
Corey>
Corey> kipmid is only started if the hardware doesn't support
Corey> interrupts, so only users with sub-standard hardware have to
Corey> suffer with this problem.

Regrettably, of the "big three" in the "PC Server" world, only HP's iLO2
BMC supports interrupts.  Dell's DRAC4 & 5 don't, IBM's ASM, RSA, etc.
don't.  Also (at least out of a sample of one) SuperMicro also doesn't
have an interrupt.

They also have all settled on the KCS interface, which dribbles one
character through per non-interrupt.  So sad.  Dell's DRAC3 had a BT BMC
which transferred whole IPMI packets via DMA _and_ had an interrupt.
HP's ancient SMIC equipment also had an interrupt (but that's also
char-by-char, and their current KCS has an interrupt, so at least they
haven't regressed).  I've guessed that some chip vendor must have
come out with a Really Cheep KCS implementation and drove every other
implementation out of the market.  :-(

I've heard rumors that some current Sun hardware has BT.

>Bela<