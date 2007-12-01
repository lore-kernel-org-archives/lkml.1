Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbXLAT6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbXLAT6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXLAT6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:58:30 -0500
Received: from il.qumranet.com ([82.166.9.18]:59984 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbXLAT63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:58:29 -0500
Message-ID: <4751BC4F.3030007@argo.co.il>
Date: Sat, 01 Dec 2007 21:55:59 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: "J.A. Magall??n" <jamagallon@ono.com>,
       Lo??c Greni?? <loic.grenie@gmail.com>, Ben.Crowhurst@stellatravel.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com> <20071201001950.11100a32@werewolf> <20071201003119.GB8181@ftp.linux.org.uk>
In-Reply-To: <20071201003119.GB8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sat, Dec 01, 2007 at 12:19:50AM +0100, J.A. Magall??n wrote:
>   
>> An vtable in C++ takes exactly the same space that the function
>> table pointer present in every driver nowadays... and probably
>> the virtual method call that C++ does itself with
>>
>> 	thing->do_something(with,this)
>>
>> like
>> 	push thing
>> 	push with
>> 	push this
>> 	call THING_vtable+indexof(do_something) // constants at compile time
>>     
>
> This is not what vtables are.  Think for a minute - all codepaths arriving
> to that point in your code will pick the address to call from the same
> location.  Either the contents of that location is constant (in which case
> you could bloody well call it directly in the first place) *or* it has to
> somehow be reassigned back and forth, according to the value of this.  The
> former is dumb, the latter - outright insane.
>
> The contents of vtables is constant.  The whole point of that thing is
> to deal with the situations where we _can't_ tell which derived class
> this ->do_something() is from; if we could tell which vtable it is at
> compile time, we wouldn't need to bother at all.
>
> It's a tradeoff - we pay the extra memory access (fetch vtable pointer, then 
> fetch method from vtable) for not having to store a slew of method pointers
> in each instance of base class.  But the extra memory access is very much
> there.  It can be further optimized away if you have several method calls
> for the same object next to each other (then vtable can be picked once),
> but it's still done at runtime.
>   

True. C++ vtables have no performance advantage over C ->ops->function() 
calls. But they have no disadvantage either and they do offer many 
syntactic advantages (such as automatically casting the object type to 
the *correct* derived class.

