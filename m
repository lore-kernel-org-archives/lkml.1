Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbYKDVhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbYKDVhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYKDVhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:37:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYKDVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:37:00 -0500
Message-ID: <4910C014.9070805@zytor.com>
Date: Tue, 04 Nov 2008 13:35:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104212933.GA11050@elte.hu>
In-Reply-To: <20081104212933.GA11050@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> And as hpa's comments point it out, compressing the rather stupid 
>> irq stubs might be a third option that looks promising as well.
> 
> ... and we should try and see how far we can compress those stubs, 
> before we do any segment register based tricks.
> 

Using the techniques previously mentioned, for 224 vectors:

1792 bytes ( 8 bytes/stub) - trivial.
1568 bytes ( 7 bytes/stub) - same without alignment.
 952 bytes (~4 bytes/stub) - extra jump needed.

For comparison, the IDT itself is 2048 bytes on x86-32 and 4096 bytes on
x86-64.

	-hpa
