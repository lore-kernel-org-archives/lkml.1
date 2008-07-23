Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYGWWyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYGWWyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYGWWyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:54:13 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24977 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYGWWyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pdByvvTYS0Pt3YdaI3Qn10kwtJlucE/PiatUlqGstc5ADblE6SMshDg/NC9aQQzKZ7
         tFI1VbDNUKGUqYT52plsV0IVbWqvyZiDRK8wRpicJhy6YEjLQHJvJPVJoPD+FEcX1s29
         BYqmsl2PojuWWQZTvzLm9HkcpMxXoatmCgApo=
Message-ID: <86802c440807231554g4fc4f981j5f9a8db9ab51fe93@mail.gmail.com>
Date: Wed, 23 Jul 2008 15:54:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] x86: usb debug port early console v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080723224533.GA29234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807231252.20371.yhlu.kernel@gmail.com>
	 <200807231400.53957.yhlu.kernel@gmail.com>
	 <20080723224533.GA29234@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 3:45 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jul 23, 2008 at 02:00:53PM -0700, Yinghai Lu wrote:
>> --- linux-2.6.orig/drivers/usb/host/ehci.h
>> +++ linux-2.6/drivers/usb/host/ehci.h
>> @@ -62,6 +62,7 @@ struct ehci_stats {
>>
>>  #define      EHCI_MAX_ROOT_PORTS     15              /* see HCS_N_PORTS */
>>
>> +#ifndef EARLY_PRINTK
>>  struct ehci_hcd {                    /* one per controller */
>>       /* glue to PCI and HCD framework */
>>       struct ehci_caps __iomem *caps;
>> @@ -207,6 +208,7 @@ timer_action (struct ehci_hcd *ehci, enu
>>               mod_timer(&ehci->watchdog, t + jiffies);
>>       }
>>  }
>> +#endif /* EARLY_PRINTK */
>>
>>  /*-------------------------------------------------------------------------*/
>>
>> @@ -352,6 +354,8 @@ struct ehci_dbg_port {
>>
>>  #define      QTD_NEXT(ehci, dma)     cpu_to_hc32(ehci, (u32)dma)
>>
>> +#ifndef EARLY_PRINTK
>> +
>>  /*
>>   * EHCI Specification 0.95 Section 3.5
>>   * QTD: describe data transfer components (buffer, direction, ...)
>> @@ -392,7 +396,7 @@ struct ehci_qtd {
>>       struct urb              *urb;                   /* qtd's urb */
>>       size_t                  length;                 /* length of buffer */
>>  } __attribute__ ((aligned (32)));
>> -
>> +#endif
>>  /* mask NakCnt+T in qh->hw_alt_next */
>>  #define QTD_MASK(ehci)       cpu_to_hc32 (ehci, ~0x1f)
>>
>> @@ -449,6 +453,7 @@ union ehci_shadow {
>>   * These appear in both the async and (for interrupt) periodic schedules.
>>   */
>>
>> +#ifndef EARLY_PRINTK
>>  struct ehci_qh {
>>       /* first part defined by EHCI spec */
>>       __hc32                  hw_next;        /* see EHCI 3.6.1 */
>> @@ -504,6 +509,7 @@ struct ehci_qh {
>>  #define NO_FRAME ((unsigned short)~0)                        /* pick new start */
>>       struct usb_device       *dev;           /* access to TT */
>>  } __attribute__ ((aligned (32)));
>> +#endif /* EARLY_PRITNK */
>>
>>  /*-------------------------------------------------------------------------*/
>>
>> @@ -517,6 +523,7 @@ struct ehci_iso_packet {
>>       u32                     buf1;
>>  };
>>
>> +#ifndef EARLY_PRINTK
>>  /* temporary schedule data for packets from iso urbs (both speeds)
>>   * each packet is one logical usb transaction to the device (not TT),
>>   * beginning at stream->next_uframe
>> @@ -651,6 +658,7 @@ struct ehci_sitd {
>>       unsigned                frame;
>>       unsigned                index;
>>  } __attribute__ ((aligned (32)));
>> +#endif
>>
>>  /*-------------------------------------------------------------------------*/
>>
>> @@ -672,6 +680,8 @@ struct ehci_fstn {
>>       union ehci_shadow       fstn_next;      /* ptr to periodic q entry */
>>  } __attribute__ ((aligned (32)));
>>
>> +#ifndef EARLY_PRINTK
>> +
>>  /*-------------------------------------------------------------------------*/
>>
>>  #ifdef CONFIG_USB_EHCI_ROOT_HUB_TT
>> @@ -843,4 +853,6 @@ static inline u32 hc32_to_cpup (const st
>>
>>  /*-------------------------------------------------------------------------*/
>>
>> +#endif /* EARLY_PRINTK */
>> +
>>  #endif /* __LINUX_EHCI_HCD_H */
>
> I don't understand the issue of any of these #ifdefs here.  Why are they
> needed?

In file included from arch/x86/kernel/early_printk.c:19:
arch/x86/kernel/../../../drivers/usb/host/ehci.h:109: error: field
'iaa_watchdog' has incomplete type
arch/x86/kernel/../../../drivers/usb/host/ehci.h:110: error: field
'watchdog' has incomplete type
arch/x86/kernel/../../../drivers/usb/host/ehci.h:142: warning: 'struct
usb_hcd' declared inside parameter list
arch/x86/kernel/../../../drivers/usb/host/ehci.h:142: warning: its
scope is only this definition or declaration, which is probably not
what you want
arch/x86/kernel/../../../drivers/usb/host/ehci.h: In function 'hcd_to_ehci':
arch/x86/kernel/../../../drivers/usb/host/ehci.h:144: error:
dereferencing pointer to incomplete type
arch/x86/kernel/../../../drivers/usb/host/ehci.h: In function 'ehci_to_hcd':
arch/x86/kernel/../../../drivers/usb/host/ehci.h:148: error:
dereferencing pointer to incomplete type
arch/x86/kernel/../../../drivers/usb/host/ehci.h:148: warning: type
defaults to 'int' in declaration of '__mptr'
arch/x86/kernel/../../../drivers/usb/host/ehci.h:148: error: invalid
use of undefined type 'struct usb_hcd'
arch/x86/kernel/../../../drivers/usb/host/ehci.h: In function
'iaa_watchdog_start':
arch/x86/kernel/../../../drivers/usb/host/ehci.h:155: error: implicit
declaration of function 'timer_pending'
arch/x86/kernel/../../../drivers/usb/host/ehci.h:156: error: implicit
declaration of function 'mod_timer'
arch/x86/kernel/../../../drivers/usb/host/ehci.h:157: error: 'jiffies'
undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:157: error: (Each
undeclared identifier is reported only once
arch/x86/kernel/../../../drivers/usb/host/ehci.h:157: error: for each
function it appears in.)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:157: error: implicit
declaration of function 'msecs_to_jiffies'
arch/x86/kernel/../../../drivers/usb/host/ehci.h:157: error:
'EHCI_IAA_MSECS' undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h: In function
'iaa_watchdog_done':
arch/x86/kernel/../../../drivers/usb/host/ehci.h:162: error: implicit
declaration of function 'del_timer'
arch/x86/kernel/../../../drivers/usb/host/ehci.h: In function 'timer_action':
arch/x86/kernel/../../../drivers/usb/host/ehci.h:194: error:
'EHCI_IO_JIFFIES' undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:197: error:
'EHCI_ASYNC_JIFFIES' undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:204: error:
'EHCI_SHRINK_FRAMES' undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:204: error: 'HZ'
undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:207: error: 'jiffies'
undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h: In function 'ehci_port_speed':
arch/x86/kernel/../../../drivers/usb/host/ehci.h:692: error:
dereferencing pointer to incomplete type
arch/x86/kernel/../../../drivers/usb/host/ehci.h:697: error:
'USB_PORT_FEAT_LOWSPEED' undeclared (first use in this function)
arch/x86/kernel/../../../drivers/usb/host/ehci.h:700: error:
'USB_PORT_FEAT_HIGHSPEED' undeclared (first use in this function)
arch/x86/kernel/early_printk.c: In function 'early_dbgp_init':
arch/x86/kernel/early_printk.c:629: warning: passing argument 3 of
'strict_strtoul' from incompatible pointer type
make[1]: *** [arch/x86/kernel/early_printk.o] Error 1


>
> And shouldn't there be a separate config option for early printk through
> the ehci debug port?

under usb or processor?

YH
