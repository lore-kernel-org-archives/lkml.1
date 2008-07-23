Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYGWUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYGWUS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYGWUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:18:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51493 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbYGWUSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CTGkrrNWTOM+/um8QFhiBAGn6CJH+u3gD9xcWWxqSKXdPdjF32CZeoLFG8C3V4sSsI
         H29mtzl2uBo6FqEMZbnoJha7q6RnX5b/eMhpZWN/XeoMAm8TuwqkkRElWFbKNIa0wW65
         NtfeLfqE2pm9aFeftEjvlOdiCf5jpjY141DOo=
Message-ID: <86802c440807231318h76ec9465td0c179668cfe4473@mail.gmail.com>
Date: Wed, 23 Jul 2008 13:18:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: usb debug port early console
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       arjan@infradead.org, ebiederm@xmission.com, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080723131218.f03ed672.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807231252.20371.yhlu.kernel@gmail.com>
	 <20080723131218.f03ed672.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 1:12 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 23 Jul 2008 12:52:20 -0700
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>>
>>
>> based on work from Eric, and add some timeout so don't dead loop when debug device
>> is not installed
>>
>>
>> ...
>>
>> +static void dbgp_mdelay(int ms)
>> +{
>> +     int i;
>> +     while (ms--) {
>> +             for (i = 0; i < 1000; i++)
>> +                     outb(0x1, 0x80);
>> +     }
>> +}
>
> hm.  port 80 has a guaranteed one microsecond?  Why not
> udelay()/mdelay()/etc?
>
>> +static void dbgp_breath(void)
>> +{
>> +     /* Sleep to give the debug port a chance to breathe */
>> +}
>
> I expect the compiler will optimise away any calls to this.
>
>>
>> ...
>>
>> --- linux-2.6.orig/arch/x86/kernel/head64.c
>> +++ linux-2.6/arch/x86/kernel/head64.c
>> @@ -72,6 +72,8 @@ static void __init copy_bootdata(char *r
>>       }
>>  }
>>
>> +extern void __init enable_debug_console(char *buf);
>
> Please always pass all patches through scripts/checkpatch.pl.
yhlu@linux-zpir:~/xx/xx/kernel/tip/linux-2.6> ./scripts/checkpatch.pl
patches/9xxx.patch
WARNING: line over 80 characters
#319: FILE: arch/x86/kernel/early_printk.c:420:
+       if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
PCI_STATUS_CAP_LIST))

WARNING: line over 80 characters
#330: FILE: arch/x86/kernel/early_printk.c:431:
+               pos = read_pci_config_byte(num, slot, func,
pos+PCI_CAP_LIST_NEXT);

WARNING: line over 80 characters
#335: FILE: arch/x86/kernel/early_printk.c:436:
+static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned
*rslot, unsigned *rfunc)

WARNING: line over 80 characters
#344: FILE: arch/x86/kernel/early_printk.c:445:
+                               class = read_pci_config(bus, slot,
func, PCI_CLASS_REVISION);

WARNING: line over 80 characters
#347: FILE: arch/x86/kernel/early_printk.c:448:
+                               cap = find_cap(bus, slot, func,
PCI_CAP_ID_EHCI_DEBUG);

WARNING: line over 80 characters
#386: FILE: arch/x86/kernel/early_printk.c:487:
+                               portsc =
readl(&ehci_regs->port_status[port - 1]);

WARNING: externs should be avoided in .c files
#425: FILE: arch/x86/kernel/early_printk.c:526:
+void early_printk(const char *fmt, ...);

WARNING: consider using strict_strtoul in preference to simple_strtoul
#518: FILE: arch/x86/kernel/early_printk.c:619:
+               dbgp_num = simple_strtoul(s, &e, 10);

WARNING: externs should be avoided in .c files
#722: FILE: arch/x86/kernel/head64.c:75:
+extern void __init enable_debug_console(char *buf);

total: 0 errors, 9 warnings, 773 lines checked

patches/9xxx.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

YH
