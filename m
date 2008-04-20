Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYDTOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYDTOXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYDTOXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:23:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbYDTOXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:23:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Higer latency with dynamic tick (need for an io-ondemand govenor?)
Date: Sun, 20 Apr 2008 09:21:38 -0500
Message-ID: <3B6D69C3A9EBCA4BA5DA60D9130274290413207D@dlee13.ent.ti.com>
In-Reply-To: <87ej90aece.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Higer latency with dynamic tick (need for an io-ondemand govenor?)
Thread-Index: Acii49NMP6nk68/TTqyR5tpGalcl4QADGxmg
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com><1179396659.3764.40.camel@chaos><3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com><1179434296.12981.14.camel@chaos><3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com><1179474567.12981.53.camel@chaos><3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com> <87ej90aece.fsf@basil.nowhere.org>
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       <lenb@kernel.org>
X-OriginalArrivalTime: 20 Apr 2008 14:21:39.0103 (UTC) FILETIME=[D8F852F0:01C8A2F1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andi Kleen" <andi@firstfloor.org> writes:
> Are you talking about x86?

ARM (TI-OMAP)

> On older x86 this effect should have been handled by the C state
> algorithm taking the bus master activity register into account (which
> should also trigger for interrupts)

Well, today we still do use the bus master hook for ARM.  In my terms it is an 'OCP bus initiator' not master.  But it is logically the same.

If some device is actively pushing data on the bus, this will limit a C-State's choice.  In our hardware if you are using the 'hw-auto' features you won't hit the state anyway even if you try as hw-activity figures into some automatic state machines. However, the cost of context savings for some of the states is high enough that it is still worth the bus-master activity check.  You want to avoid unnecessary context stacking if you are not going to hit the state.

> But I think the register has been nop'ed on newer platforms
> so indeed we'll need some way to handle this.

The activity is still useful.  Not sure about the underlying X86 hardware implementation.  For me it's just exporting some activity for masters & slaves as seen by the interconnect.

Regards,
Richard W.

