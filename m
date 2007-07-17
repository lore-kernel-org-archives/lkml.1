Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXGQBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXGQBGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932603AbXGQBFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:05:55 -0400
Received: from gw.goop.org ([64.81.55.164]:33006 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559AbXGQBFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:05:53 -0400
Message-ID: <469C15B6.8070002@goop.org>
Date: Mon, 16 Jul 2007 18:04:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.com>,
       Zachary Amsden <zach@vmware.com>,
       Xen-devel <xen-devel@lists.xensource.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [Xen-devel] [patch 17/44] Add nosegneg capability to the	vsyscall
 page notes
References: <20070716231536.937393000@xensource.com> >	  <20070716232914.029797000@xensource.com>> <1184633155.5955.29.camel@localhost.localdomain>
In-Reply-To: <1184633155.5955.29.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Mon, 2007-07-16 at 16:15 -0700, Jeremy Fitzhardinge wrote:
>   
>> plain text document attachment (xen-vsyscall-note.patch)
>> Add the "nosegneg" fake capabilty to the vsyscall page notes. This is
>> used by the runtime linker to select a glibc version which then
>> disables negative-offset accesses to the thread-local segment via
>> %gs. These accesses require emulation in Xen (because segments are
>> truncated to protect the hypervisor address space) and avoiding them
>> provides a measurable performance boost.
>>     
>
> Hmm, this is still unconditional?  Not that it causes any measurable
> slowdown when enabled, but ISTR discussing making this dynamic...

Played with it for a bit, but it's fairly fiddly.  Didn't seem like it
was worth the complexity.

    J

