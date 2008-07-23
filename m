Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYGWXqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYGWXqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYGWXqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:46:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60143 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYGWXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sXGrzFH5bgF+A9MqqDMYkoBDkX6GGHpkrwwph+HFyMQPnjpO4kOYv3rZzMKn+X8tpG
         zQSvgTuVxp4e+bvivl97pZzSsGPi848Py8a7fpQJw3AcGbfkH0ug24i+l1fw4+NP2YvW
         x1ED+cEI7683hEpFruz8g534ngOLCGwlKC6pU=
Message-ID: <86802c440807231646t11313612x4107c2c780d2b0f9@mail.gmail.com>
Date: Wed, 23 Jul 2008 16:46:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] x86: usb debug port early console v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080723232142.GD30234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807231252.20371.yhlu.kernel@gmail.com>
	 <200807231400.53957.yhlu.kernel@gmail.com>
	 <20080723224533.GA29234@kroah.com>
	 <86802c440807231554g4fc4f981j5f9a8db9ab51fe93@mail.gmail.com>
	 <20080723232142.GD30234@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 4:21 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jul 23, 2008 at 03:54:09PM -0700, Yinghai Lu wrote:
>> On Wed, Jul 23, 2008 at 3:45 PM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, Jul 23, 2008 at 02:00:53PM -0700, Yinghai Lu wrote:
>> >> --- linux-2.6.orig/drivers/usb/host/ehci.h
>> >> +++ linux-2.6/drivers/usb/host/ehci.h
>> >
>> > I don't understand the issue of any of these #ifdefs here.  Why are they
>> > needed?
>>
>> In file included from arch/x86/kernel/early_printk.c:19:
>> arch/x86/kernel/../../../drivers/usb/host/ehci.h:109: error: field
>> 'iaa_watchdog' has incomplete type
>
> Ah, so you are papering over the real problem here, right?
>
> Why not just include the properly needed #includes either where you are
> including this header file, or add the dependancies to the ehci.h file
> itself (which is usually preferred.)

how about moving

struct ehci_caps;
struct ehci_regs;
struct ehci_dbg_port;

to one header file in include/usb
so could use
#include <linux/usb/ehci_def.h>
instead of
#include "../../../drivers/usb/host/ehci.h"

>
>> > And shouldn't there be a separate config option for early printk through
>> > the ehci debug port?
>>
>> under usb or processor?
>
> Somewhere.
>
> Also, usb patches should be cc:ed to the linux-usb mailing list.  I'm
> sure the EHCI authors would like to comment on this patch...

oh, i thought you wrote the ehci code.

YH
