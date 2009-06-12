Return-Path: <linux-kernel-owner+w=401wt.eu-S934484AbZFLW1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbZFLW1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbZFLW1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:27:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZFLW1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:27:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=U2FGFL02Cvae+U1/hap14kGgsOfFFUuKUIXByZp2UWp9y/UP4dOZLx8QExleXz7WU
	DhrWty6v8Z1tFml/8NVdA==
MIME-Version: 1.0
In-Reply-To: <4A32D079.9030707@mnementh.co.uk>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
	 <20090610213710.GA8472@elf.ucw.cz>
	 <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
	 <20090611082532.GE8592@elf.ucw.cz>
	 <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
	 <20090612150504.GA15084@elf.ucw.cz>
	 <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
	 <4A32D079.9030707@mnementh.co.uk>
Date: Fri, 12 Jun 2009 15:27:01 -0700
Message-ID: <a55d774e0906121527n16019225q81084945a38bb97e@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Pavel Machek <pavel@ucw.cz>,
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

On Fri, Jun 12, 2009 at 3:02 PM, Ian Molton<ian@mnementh.co.uk> wrote:
> Brian Swetland wrote:
>
>> Yup.  It's an HTC specific thing -- some of their devices don't have a
>> battery gauge IC and estimate current drain based on hints provided to
>> the baseband from the apps processor.  I'm not particularly thrilled
>> with the interface, but without it the battery level estimation is
>> flakier.
>
> Is there a reason that this couldnt be done in userspace?

It'd be a lot more overhead -- in some cases it's updated with
relatively fine granularity (wifi driver changing state, backlight
changing, etc), and on the kernel side it's just updating a shared
memory location with the current estimate.  Userspace doesn't
necessarily have the visibility into driver state to update it
accurately, and punching that information down to userspace and then
having userspace feed it back up to the kernel seems like more
overhead and code to maintain to me.

Brian
