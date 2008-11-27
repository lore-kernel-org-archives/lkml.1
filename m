Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYK0K57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYK0K57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYK0KqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:46:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48912 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800AbYK0KqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:46:05 -0500
Date: Thu, 27 Nov 2008 11:56:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64,	i386: interrupt dispatch changes
Message-ID: <20081127105635.GG6703@one.firstfloor.org>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com> <492DC13F.8020009@redhat.com> <492DE3EF.8060507@zytor.com> <492E72D7.9060201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492E72D7.9060201@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 12:13:43PM +0200, Avi Kivity wrote:
> H. Peter Anvin wrote:
> >
> >>I suspect we could get it down to three bytes, by sharing the last 
> >>byte of the four-byte call sequence with the first byte of the next:
> >>
> >> 66 e8 ff 66 e8 fc 66 e8 f9 66 e8 f6 ...
> >>
> >>Every three bytes a new stub begins; it's a four-byte call to offset 
> >>0x6703 relative to the beginning of the first stub.
> >>
> >>Can anyone better 24 bits/stub?
> >
> >On the entirely silly level...
> >
> >CC xx
> 
> Nice.  Can actually go to zero, by pointing the IDT at (unmapped_area + 
> vector), and deducing the vector in the page fault handler from cr2.

That would be still one byte, otherwise you wouldn't get a unique index.

-Andi

-- 
ak@linux.intel.com
