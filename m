Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYGOCwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYGOCwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbYGOCwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:52:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:37578 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893AbYGOCwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:52:21 -0400
Date: Mon, 14 Jul 2008 19:52:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: David Woodhouse <dwmw2@infradead.org>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
In-Reply-To: <1216088636.27455.163.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807141949100.6370@asgard>
References: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm>  <1216082213.27455.109.camel@shinybook.infradead.org>  <487C0788.7030907@garzik.org>  <20080714.191727.223788995.davem@davemloft.net> <1216088636.27455.163.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, David Woodhouse wrote:

> On Mon, 2008-07-14 at 19:17 -0700, David Miller wrote:
>> When module support was added, guess what?  I could still build a
>> completely static kernel image like I always could.
>>
>> And in fact, to this day, that's what I personally do because that's
>> how I like my kernels.
>
> Good. You can still do precisely that, and build the firmware into your
> kernel. You can have exactly what you like. Hey, you can build even
> _more_ firmware into your kernel now. You can have NFS-root on devices
> you previously had to use an initrd for. hth.

we recognise that a monolithic kernel can have the firmware embedded in it 
(and I thank you for doing so, this will help me with my Intel wireless 
cards). the objection is that you can't embed firmware into modules.

>> But this request_firmware() change does not allow one to get what he
>> could get before, which is a completely self-contained driver module
>> object file.
>>
>> This is the difference between providing an option and making
>> something mandatory.  This firmware split up is now mandatory.
>
> In all the years we've been using request_firmware(), nobody ever asked
> for a way to build the firmware _into_ the .ko file, until now. Why is
> it suddenly so important for a small handful of older network drivers,
> when nobody else has ever seen the need for it -- even in modern network
> drivers?

the reason the objections are showing up now is that the drivers that 
previously had the firmware embedded in them (so that nobody but the 
driver author needed to even know that there _was_ firmware involved) are 
now being converted to use request_firmware(). that change is breaking the 
invisability of the firmware that they have cultivated. if they had the 
option to keep things as they are (even while you provide the option for 
others to move the firmware out) they could not object like they are.

David Lang
