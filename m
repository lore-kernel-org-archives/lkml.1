Return-Path: <linux-kernel-owner+w=401wt.eu-S2993050AbXDYUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993050AbXDYUai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993102AbXDYUai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:30:38 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2267 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993050AbXDYUah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:30:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 25 Apr 2007 20:30:31.0034 (UTC) FILETIME=[91813DA0:01C78778]
Content-class: urn:content-classes:message
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
Date: Wed, 25 Apr 2007 16:30:29 -0400
Message-ID: <Pine.LNX.4.61.0704251612090.27302@chaos.analogic.com>
In-Reply-To: <jetzv41aot.fsf@sykes.suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH] fix abs() macro to work with types wider than int
Thread-Index: AceHeJGKsBwGgn29RE+Ts/VuobbyeQ==
References: <20070419092339.GA13569@dwarf.suse.cz><20070419084339.418dbe69.randy.dunlap@oracle.com><4628B5B6.90303@student.ltu.se><20070425082028.8ece3094.randy.dunlap@oracle.com><alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com><Pine.LNX.4.61.0704251418010.26778@chaos.analogic.com> <jetzv41aot.fsf@sykes.suse.de>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Andreas Schwab" <schwab@suse.de>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Jiri Bohac" <jbohac@suse.cz>, <akpm@osdl.org>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Apr 2007, Andreas Schwab wrote:

> "linux-os (Dick Johnson)" <linux-os@analogic.com> writes:
>
>> I think this works, regardless of the length of the integers:
>>
>> #define abs(x) (((x)<0)?-(x):(x))
>
> But it evaluates its argument more than once.
>
> Andreas.
>

Sure. Macros do that. If that's not okay, then you need either
a temporary variable or a function. The original query was for
a macro. Any macro that tests something then returns a value
based upon the test is going to have that problem. Any attempt
to just AND off a sign bit is going to have width problems. You
can't have your cake and eat it too. Even whacking off the sign-
bit may fail because there may be two variable accesses which could
mean two function calls, destroying the logic.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.62 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
