Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYKESjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYKESjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYKESg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:36:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:17653 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYKESg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:36:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lhMXAzKbCPhlxv7U3vDmJV4CxINQHkaWMZ5HoLCy76eMemmyQZ8v9GJSwicK03NnEb
         YzasMjNeNjtfcw6HnTpxoGvofIa7nUoFu7diQtdjH7mROj7hTTQxXS1szOLpFLnIyqe7
         XGh09AA6Bd8bBeQYL2Xd88v0svl6MWDvussaY=
Message-ID: <8bd0f97a0811051036w32717036k337f3ce1b3194198@mail.gmail.com>
Date: Wed, 5 Nov 2008 13:36:56 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Cc: "Greg KH" <gregkh@suse.de>, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081105182743.GE6382@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
	 <20081105113610.GA6382@local> <20081105163334.GA8473@suse.de>
	 <8bd0f97a0811050933m13addb7eiddb963bfdf4d7416@mail.gmail.com>
	 <20081105182743.GE6382@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 13:27, Hans J. Koch wrote:
> On Wed, Nov 05, 2008 at 12:33:37PM -0500, Mike Frysinger wrote:
>> On Wed, Nov 5, 2008 at 11:33, Greg KH wrote:
>> > On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
>> >> There seem to be archs that cannot easily implement a sensible
>> >> pgprot_noncached() function, so we should merge this patch. UIO doesn't
>> >> compile on these archs right now.
>> >
>> > No, we should fix those arches to have that function at least NULLed
>> > out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
>> > not something we really want to do if at all possible.
>>
>> that was my question.  this function isnt documented.  if the hardware
>> doesnt support it, is the right thing really for the arch to lie to
>> drivers and not actually give back cached settings even though it
>> asked for non-cached ?
>
> Well, if there's no possibility to map device memory in a non-cached
> way, it's very likely you don't want to use UIO at all. If there's a few
> seconds between a write and the value actually appearing in the hardware
> register, you will certainly don't see the results you expect.
>
> If Blackfin can't mmap non-cached memory, we should make UIO depend on
> !BLACKFIN.

if it wasnt usable on the Blackfin arch, i wouldnt have been looking
at it in the first place.  there is some usage where merely hooking up
an interrupt is the only thing that is needed by userspace.

the only memory regions where a device would be hooked up are never
marked as cachable.  so if this function is only for mapping addresses
where device registers would live, then a stub pgprot_noncached()
would be fine.  but we cant do non-cached access on external memory
(e.g. SDRAM / DDR) if the device wanted coherent memory for dma.
-mike
