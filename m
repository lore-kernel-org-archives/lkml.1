Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYH2XYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYH2XYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYH2XYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:24:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:29495 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYH2XYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jvOcD+Sh63/9Ijteg3/olQ2skTcMoKc1iyEZqbjXwrvvJJqogPAHe6gTpCCJ6SyA6X
         M5Qvf/opdChqF7hPE5i/H6qisVlaL7TJLtOi9P++zDw1Qei9YGML9wk6yrk+uJie4Ulx
         mcScvUhKshf0xAgab2H5L6n9yjdgez5RLpt2M=
Message-ID: <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
Date: Fri, 29 Aug 2008 16:24:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <200808300031.16708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
	 <200808300031.16708.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 3:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 29 of August 2008, Yinghai Lu wrote:
>> On Fri, Aug 29, 2008 at 12:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, 29 of August 2008, Rafael J. Wysocki wrote:
>> >> On Friday, 29 of August 2008, Linus Torvalds wrote:
>> >> >
>> >> > Another week (my weeks do seem to be eight days, don't they? Very odd),
>> >> > another -rc.
>> >> >
>> >> > The dirstat pretty much says it all:
>> >> >
>> >> >   43.0% arch/arm/configs/
>> >> >   43.9% arch/arm/
>> >> >   25.5% arch/powerpc/configs/
>> >> >   26.8% arch/powerpc/
>> >> >   73.9% arch/
>> >> >    4.4% drivers/usb/musb/
>> >> >    5.4% drivers/usb/
>> >> >    4.0% drivers/watchdog/
>> >> >   16.0% drivers/
>> >> >    3.5% fs/
>> >> >
>> >> > yeah, the bulk of it is all config updates, and with arm and powerpc
>> >> > leading the pack.
>> >>
>> >> Doesn't boot on my quad core test box, apparently because of an AHCI failure.
>> >>
>> >> Bisecting ...
>> >
>> > Bisection turned up commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd as the culprit:
>> >
>> > commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
>> > Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> > Date:   Mon Aug 25 00:56:08 2008 -0700
>> >
>> >    x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3
>> >
>> > Reverting this commit helps.
>> >
>>
>> can i get whole bootlog with "debug"?
>
> http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/broken.log
>


pci 0000:00:00.0: BAR has MMCONFIG at e0000000-ffffffff
pci 0000:00:12.0: BAR 5: can't allocate resource
pci 0000:00:13.0: BAR 0: can't allocate resource
pci 0000:00:13.1: BAR 0: can't allocate resource
pci 0000:00:13.2: BAR 0: can't allocate resource
pci 0000:00:13.3: BAR 0: can't allocate resource
pci 0000:00:13.4: BAR 0: can't allocate resource
pci 0000:00:13.5: BAR 0: can't allocate resource
pci 0000:00:14.2: BAR 0: can't allocate resource

your mmconf in BAR is broken....

after forcibly insert that block all others...

YH
