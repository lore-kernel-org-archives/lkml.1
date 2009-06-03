Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZFCXwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZFCXwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZFCXwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:52:46 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:6963 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZFCXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VJJ72DZ/AUyDIaAZytitoD0tUKELo+cY6Px0e/ERPWieB8B8iGshXGSkepoGNrqJ8Z
         Zz9shaosrw8Ru1Hkmmv5EnG2mDmM6eUx2OjhmINGRzwRg1hGHJv1Nl6tHi5Y89JVekNk
         bReT54aREDbi+CeI6rCCidzKvt4Tkk7DC4zNc=
Message-ID: <4A270CCD.2020708@gmail.com>
Date: Wed, 03 Jun 2009 17:52:45 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: stefan verse <stefan.verse@post.rwth-aachen.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: possible Bug in IOAPIC concerning serial 8250
References: <2CE90141F99649C08429B52D22C5066A@pepe>
In-Reply-To: <2CE90141F99649C08429B52D22C5066A@pepe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefan verse wrote:
> Hello,
> i know, no good place to start, but my problem is a little bit
> unspecific concerning Problems with IOAPIC concerning serrial driver
> 8250 :
> 
> 1. serial driver 8250 is loaded, but /dev/ttyS0 is unusable
> 
> 2. hardware is a d945gclf2 mini-itx board from intel, distribution is
> easyvdr 0.6.06., Kernel Version is 2.6.29.3, serial port is activated in
> BIOS, BIOS rev LF94510J.86A.0171.2009.0403.0118
> 
> dmesg reports :
> [   21.682611] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
> [   21.682789] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   21.711689] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 
> and lsmod :
> 8250_pci               27412  0
> 8250_pnp               14036  0
> 8250                   20516  2 8250_pci,8250_pnp
> serial_core            18708  1 8250
> 
> so driver is loaded 
> 
> ls -lpr /dev/ttyS0
> crw-rw-rw- 1 root tty 4, 64 2009-06-03 07:55 /dev/ttyS0
> seems ok to me
> 
> but cat < /dev/ttyS0 gives :
> cat: -: Eingabe-/Ausgabefehler                  (I/O Error)
> 
> /proc/interrupts is missing driver for irq4 :

I think this is normal, the driver only claims the interrupt while the 
device is actually open. Do any dmesg messages result from trying to cat 
the device?
