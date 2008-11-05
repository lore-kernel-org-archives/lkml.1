Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYKEAzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYKEAzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYKEAzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:55:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYKEAzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:55:03 -0500
Message-ID: <4910EDCF.2050206@zytor.com>
Date: Tue, 04 Nov 2008 16:50:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104210643.GH29626@one.firstfloor.org> <4910EBF5.7070506@goop.org>
In-Reply-To: <4910EBF5.7070506@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>> ???  LOCK slowness is not because of the bus. And I know you know that
>> Ingo, so I don't know why you wrote that bogosity above.
>>   
> 
> Why are the accesses locked?  Is it because it does an update of the
> accessed bit in the descriptor?  (We should be pre-setting them all
> anyway.)
> 

It is, but the locked access is unconditional.  Similar to any other
read/modify/write transaction -- the write is required to release the lock.

	-hpa
