Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZFLWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZFLWgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZFLWgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:36:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47675 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZFLWgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:36:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=U6LnP6h1NKq/h91V/bV4r3k9xrRqX8kZjqMT4mFlccL+ePvqf9tUbd4vWUUxhT+1k
	RvTp2YSOpCt7FTl2emHuQ==
MIME-Version: 1.0
In-Reply-To: <20090612223141.GF17688@elf.ucw.cz>
References: <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <20090610213710.GA8472@elf.ucw.cz>
	 <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
	 <20090611082532.GE8592@elf.ucw.cz>
	 <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
	 <20090612150504.GA15084@elf.ucw.cz>
	 <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
	 <4A32D079.9030707@mnementh.co.uk>
	 <a55d774e0906121527n16019225q81084945a38bb97e@mail.gmail.com>
	 <20090612223141.GF17688@elf.ucw.cz>
Date: Fri, 12 Jun 2009 15:36:08 -0700
Message-ID: <a55d774e0906121536m41715207td0cab3ba41d03bf2@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 3:31 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> > Is there a reason that this couldnt be done in userspace?
>>
>> It'd be a lot more overhead -- in some cases it's updated with
>> relatively fine granularity (wifi driver changing state, backlight
>> changing, etc), and on the kernel side it's just updating a shared
>> memory location with the current estimate.  Userspace doesn't
>> necessarily have the visibility into driver state to update it
>> accurately, and punching that information down to userspace and then
>> having userspace feed it back up to the kernel seems like more
>> overhead and code to maintain to me.
>
> Actually I agree with Brian here, this is better done at kernel level.
>
> OTOH, at least initially, it does not need to be done at all. It will
> make battery readings less reliable but hey... the battery meter does
> not work reliably anyway and estimating capacity left from voltage
> acceptably on other platforms...

I'd agree.  This stuff can wait until the core support is solid.  I'd
fight harder for conditional support for wakelocks since that has a
much bigger impact on battery life (being able to know when it's safe
to power collapse in idle, etc), whereas this just improves the
accuracy of the battery gauging.

Brian
