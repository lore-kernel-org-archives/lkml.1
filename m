Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0BBJEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:04:42 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:23791 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0BBJEh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Tue, 2 Feb 2010 04:04:37 -0500
Message-Id: <4B67F8B1020000780002D218@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 02 Feb 2010 09:04:33 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: enlightenment for ticket spinlocks - base
	 implementation
References: <4B62A3BD020000780002CA83@vpn.id2.novell.com>
 <4B675BBE.7080800@zytor.com>
In-Reply-To: <4B675BBE.7080800@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 01.02.10 23:54 >>>
>I'm really not very happy with the way the asm statement is chopped to
>bits here.  It is quite frankly much cleaner to have a little bit of
>code replication and have two separate clean asm/alternative_io
>implementations.

Yeah, that's a tradeoff I wasn't sure about either. I can easily change
this, but to me it seemed more desirable to have less duplication.

>A thought, however:
>
>the sequence "rep;nop; movb %1,%b0" should be enough bytes to be able to
>overwrite it with a call instruction.  I am not sure if the existing

Hmm, yes, including the branch there would be 6 bytes guaranteed.

>macros allow for overwriting part of an asm statement, but it might be
>an interesting thing to do.  That should eliminate the funnies you have

They don't currently, but adding an offset shouldn't be that difficult.
The goal certainly was to avoid touching the alternative instructions
infrastructure more than absolutely necessary.

>with rip-relative addressing (which may very well be the preferred
>addressing modes.)  It should also give you the return address without
>having to play games with pushing it onto the stack as anything other
>than a return address...

Yes, for the locking path. The unlocking path could also be done with
a "proper" call (even without adjustments to the alternative instructions
data structures), but would introduce more branches in the inline stub.
It's not clear to me whether that's better.

So if you want me to give that a try, I certainly will, provided the
alternative instructions adjustments needed won't increase the
resistance to the patch.

Jan

