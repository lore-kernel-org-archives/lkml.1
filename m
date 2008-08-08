Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYHHGzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYHHGzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYHHGxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:53:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:48592 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbYHHGxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HBKRZBNAlJS8LEIw00rM6QWjKWxoE1+dJb85iZK2M9CnTi+0HApC9qRyPTMfCO++gg
         KqUvDHExaNosTAHZDYGwzvb3iXued6tjMGU83kDhyxsvyC/3KnSE1Gc/OppAAojRcAVT
         kvW135LW4opYvPv1QclI/GJSnK2L+0IP8FMac=
Message-ID: <ac9c93b10808072353g550f0f71pca977f9f6eb6d794@mail.gmail.com>
Date: Fri, 8 Aug 2008 08:53:23 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: initramfs optimization suggestions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <489B30B3.8050709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
	 <489A40FF.1000508@zytor.com>
	 <ac9c93b10808070011x7a84adb5v98d2ed2405835fcc@mail.gmail.com>
	 <489B30B3.8050709@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed quoted text heavily; please refer to earlier msg if you need
the full text]

2008/8/7 H. Peter Anvin <hpa@zytor.com>:
> Frans Meulenbroeks wrote:

[...]

> Having a CONFIG option to make this image uncompressed would be a good idea.

Ok. Doesn't look too difficult. I'll put it on my TODO list (but don't
expect anything this weekend, fully booked already :-) )


>> Agree about the footprint but as this is only during booting the
>> memory is on most systems available anyway (and I assume the memory
>> occupied by init.ramfs is reclaimed later on).
>
> It is, however, due to lowmem restrictions on a lot of systems this can
> still hurt.

Sorry, I miss what lowmem restrictions you mean.
You're not talking 8088 or so, are you ?

Besides that: my proposed changes still could be an option. If you
have restrictions, then don't use it.

As I wrote before: for embedded systems this could make a lot of difference.
Instead of storing the application in a squashfs, you could directly
store it into the buffer cache (where it also ends up through ramfs).

Note also that I am not saying the proposal is a replacement for
initramfs. I can imagine they can live besides each other.
But for systems where fast boot is important it would help if the
gunzip/parse cpio/copy data steps can be skipped.
An initialised buffer cache (together with some associated data
structures of course) could be a nice alternative.

[...]

>
> I think the complexity penalty would be prohibitive; plus, on
> HIGHMEM-afflicted system, this would move the initramfs from highmem to
> lowmem, which would be highly undesirable.

As said before, I'm not sure what you mean with HIGHMEM. For me this
is something from the 8088/80286 era.
(and wikipedia tells me the same). Please educate me by providing a
pointer to some info.

Having said that I do not understand why this would move at all.
If I have the initramfs build into my kernel it occupies memory when
loaded. If the same data moves from the init.ramfs section to fs or mm
in order to have some initialised data structures, it just moved to a
different place in the image that is loaded.
The key difference is that the initramfs can be compressed, but if we
decide to implement an option to do things uncompressed (which you
agreed to be a good plan), then at least with an uncompressed
initramfs there does not seem too much of a difference.

>
> Overall, part of the attractiveness of the current code is that it is
> extremely simple.  There are reasons it could use to be cleaned up (I found
> its producer/consumer model to be a little to implicit to make it easy to
> support loading from highmem proper) but I don't believe in the model of
> going in and mucking with ramfs internals.

The current code is indeed very simple.

The amount of complication added by another solution remains to be
investigated. Definitely it will not simplify the code, but there is
also a gain associated with it. A gain which might not be too
interesting if you run a fast PC which only boots rarely, but which is
very interesting if you have a low performance embedded system that
needs to boot up quickly (I'm thinking here about systems like set-top
boxes, digital camera's, tv's etc).

Best regards, Frans.
