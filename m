Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZI2TML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZI2TML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZI2TMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:12:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbZI2TMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:12:09 -0400
Date: Tue, 29 Sep 2009 12:10:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
In-Reply-To: <20090929210207.247b94df@infradead.org>
Message-ID: <alpine.LFD.2.01.0909291207410.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com> <200909242343.59903.arnd@arndb.de> <20090925082346.GB4436@localdomain> <20090925105632.GG12824@hawkmoon.kerlabs.com> <20090929180537.GD4625@us.ibm.com>
 <20090929184023.532DF34@magilla.sf.frob.com> <4AC255A4.4030002@zytor.com> <20090929210207.247b94df@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Sep 2009, Arjan van de Ven wrote:
> > 
> > We already have a syscall layer which is painful to thunk in places,
> > and this would make it much worse.
> 
> syscalls are cheap as well.
> cheaper than decades of dealing with such multiplexer mess ;/

Well, I'd agree, except the clone flags really _are_ about multiplexer 
issues, and the new flag woudln't really change anything. 

If the new system call actually had appreciably separate code-paths, I'd 
buy the "multiplexer" argument. But it doesn't really. It's going to call 
down to the same basic clone functionality, and the core clone code ends 
up de-multiplexing the cases anyway.

So this would not at all be like the socket calls (to pick the traditional 
Linux system call multiplexing example) in that sense.

			Linus
