Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZI2UN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZI2UN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZI2UN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:13:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZI2UN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:13:27 -0400
Message-ID: <4AC267C7.4070300@zytor.com>
Date: Tue, 29 Sep 2009 13:02:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com> <200909242343.59903.arnd@arndb.de> <20090925082346.GB4436@localdomain> <20090925105632.GG12824@hawkmoon.kerlabs.com> <20090929180537.GD4625@us.ibm.com> <20090929184023.532DF34@magilla.sf.frob.com> <4AC255A4.4030002@zytor.com> <20090929210207.247b94df@infradead.org> <alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 12:10 PM, Linus Torvalds wrote:
> 
> On Tue, 29 Sep 2009, Arjan van de Ven wrote:
>>>
>>> We already have a syscall layer which is painful to thunk in places,
>>> and this would make it much worse.
>>
>> syscalls are cheap as well.
>> cheaper than decades of dealing with such multiplexer mess ;/
> 
> Well, I'd agree, except the clone flags really _are_ about multiplexer 
> issues, and the new flag woudln't really change anything. 
> 
> If the new system call actually had appreciably separate code-paths, I'd 
> buy the "multiplexer" argument. But it doesn't really. It's going to call 
> down to the same basic clone functionality, and the core clone code ends 
> up de-multiplexing the cases anyway.
> 
> So this would not at all be like the socket calls (to pick the traditional 
> Linux system call multiplexing example) in that sense.
> 

That's not the main issue here, though.  The main issue is that the
prototype of the function now depends on one of its arguments, which is
absolute hell for anything that needs to thunk arguments in a systematic
way, which we have to do on several architectures, and which would be
useful to be able to do for others, too.

	-hpa

