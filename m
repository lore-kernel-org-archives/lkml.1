Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYKKQZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYKKQZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYKKQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:25:26 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14488 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYKKQZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:25:25 -0500
From: "Altobelli, David" <david.altobelli@hp.com>
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Grant Grundler <grundler@parisc-linux.org>
Date: Tue, 11 Nov 2008 16:24:58 +0000
Subject: RE: sharing interrupt between PCI device
Thread-Topic: sharing interrupt between PCI device
Thread-Index: AclDufUhqqa23HyeS3yTLfK8m2qWuQAXsvfQ
Message-ID: <92D64232F2316045B18937D5C9996B152252BB941B@GVW1144EXB.americas.hpqcorp.net>
References: <4910E8AC.7050407@shaw.ca>
 <20081108172716.GA28039@colo.lackof.org>	 <4915E43E.4010206@gmail.com>
 <20081108191536.GC28039@colo.lackof.org>
	 <8d6898730811092235u4a41c664vd641d2792dee4c50@mail.gmail.com>
	 <20081110075115.GA13239@colo.lackof.org>	 <20081110075827.GE2093@elte.hu>
	 <8d6898730811100231j2ca5e8ceub0d5137c1ef1f9d0@mail.gmail.com>
	 <8d6898730811100742g31711b9ck9e046d77273d0113@mail.gmail.com>
	 <20081110203454.GB18188@colo.lackof.org>,<8d6898730811102057u55b9495fxf640af7df3271878@mail.gmail.com>
In-Reply-To: <8d6898730811102057u55b9495fxf640af7df3271878@mail.gmail.com>
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


>> On Mon, Nov 10, 2008 at 4:01 PM, Nobin Mathew <nobin.mathew@gmail.com> wrote:
>> > Yes USB Virtual Controller has input devices like keyboard and mouse
>> > (routed through hpilo card (remote console)), so those things stops
>> > working when we remove hpilo driver.
>> >

That is not quite correct.  Nothing is routed through hpilo.

The problem is that there is a shared hardware resource in iLO function 2 (hpilo),
and it is used by iLO function 4 (uhci_hcd kdb/mouse).  When hpilo is unloaded,
the pci_device_disable() call removes the ability for this function to act as a
busmaster, which stops the uhci_hcd from functioning correctly.

Reloading hpilo will enable the remote console again.

Removing the pci_disable_device() "fixes" the problem, but doing that worries me.
