Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYHaRyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYHaRyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYHaRyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:54:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:4058 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYHaRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QIyCTYYRVVxQ29QI1Wq4bAuWnHvJ4h/RTbDnVrmdPiLrRtJ749apobpdGpn0TQMjcy
         +OE/0HB8rCL+4L0gNHg9Jf7ZX9PlwlY8oyF50A/UV91XMw4Mx7PMhRq8PNDdywXVvtkp
         HL4mnqViH+XZ4ResirHbiBU9VSwKg+MoWZRo4=
Message-ID: <86802c440808311054q4b8e8921qa9f090527b456e34@mail.gmail.com>
Date: Sun, 31 Aug 2008 10:54:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808311039330.12958@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808302334.29156.rjw@sisk.pl>
	 <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com>
	 <200808311427.19369.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808311039330.12958@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 10:42 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 31 Aug 2008, Rafael J. Wysocki wrote:
>>
>> Works, dmesg is at:
>> http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/2.6.27-rc5-test.log
>
> That BAR is indeed "locked". Now that we try to reallocate it, you get
> this in the log:
>
>        pci 0000:00:00.0: BAR 3: error updating (0x40000004 != 0xe0000004)
>        pci 0000:00:00.0: BAR 3: error updating (high 0x000001 != 0x000000)
>
> ie now the code _tried_ to update the BAR to point to 0x1_4000_0000
> instead, but the hardware refused, and it is still at 0x0_e000_0000.
>
> So Yinghai's patch "worked", but it worked by doing nothing.
>
> See my earlier guess about locked read-only resources a few emails back.
> IOW, I'm not at all surprised. I really do suspect that that BAR is some
> very special "this is the HT->PCIE region" BAR.

so the code could allocate the 64 bit resource above 4g,...

wonder how the probe could find out the size of is 1fff_ffff..

YH
