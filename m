Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbZI3Q3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbZI3Q3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZI3Q3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:29:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753088AbZI3Q3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:29:25 -0400
Date: Wed, 30 Sep 2009 09:27:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
In-Reply-To: <200909301815.45211.arnd@arndb.de>
Message-ID: <alpine.LFD.2.01.0909300925170.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com> <alpine.LFD.2.01.0909291501530.6996@localhost.localdomain> <4AC287F2.8060603@zytor.com> <200909301815.45211.arnd@arndb.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Arnd Bergmann wrote:
> 
> One more argument for this is that the new code is architecture independent
> using user_stack_pointer(), while the original sys_clone is highly
> architecture specific, which is a source for bugs when trying to
> extend it.

Umm. I don't think that is possible.

You need architecture-specific code to even get access to all registers to 
copy and get a signal-handler-compatible stack frame. See for example 
arch/alpha/kernel/entry.S with the switch-stack thing etc.  I don't think 
there is any way to make that even remotely architecture-neutral.

			Linus
