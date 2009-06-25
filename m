Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZFYGew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZFYGew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFYGeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:34:44 -0400
Received: from mail-gx0-f222.google.com ([209.85.217.222]:53791 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZFYGen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:34:43 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 02:34:42 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wOfV4umurfZ7Uto7JIjuCa66AAno0TF0EPycsKOIzlPq0FZHrol4+SifOdpXMEFIRM
         /J2wnGk5rXajWElXJFkxNqLjCOi9Embq8IqKqjlPOTDZ/FdzeryPfobfH2TcDD0YL0dm
         dyDXNRFMYkpueDvLnX89Zl/eVYURYycuq9j5E=
MIME-Version: 1.0
In-Reply-To: <1245884203.21200.18.camel@pasglop>
References: <cb9ecdfa0906232050n6fcfee31ubeee4bcd9b8c0dfe@mail.gmail.com>
	 <4A41B3A5.9010807@am.sony.com> <1245884203.21200.18.camel@pasglop>
Date: Thu, 25 Jun 2009 14:27:54 +0800
Message-ID: <cb9ecdfa0906242327j76d1e4fbib13bc7d9753aeacf@mail.gmail.com>
Subject: Re: How the kernel printk works before do console_setup.
From: Johnny Hung <johnny.hacking@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tim Bird <tim.bird@am.sony.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/25 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
>
>> Before the console is set up, the printk data is formatted
>> and put into the kernel log buffer, but not sent to any console.
>> Any messages printk'ed before that are buffered but do not
>> appear.  When the console is initialized, then all buffered
>> messages are sent to the console, and subsequent printks cause
>> the message to go to the log buffer, but then immediately
>> get sent from there to the console.
>>
>> Under certain conditions you can examine the log buffer of
>> a kernel that failed to initialize it's console, after a
>> warm reset of the machine, using the firmware memory dump
>> command.
>
> On ppc, we have tricks to display things earlier :-)
>
> We can initialize the serial ports way before console_setup() (and we do
> in most cases) and we use what we call the "udbg" console until the real
> one takes over. The "udbg" console is a very small layer which outputs
> via a provided "putc" routine. Platforms can provide their own here, we
> have a collection of standard ones for legacy UARTs (it should be
> automatically setup in that case by the code in legacy_serial), Apple
> ESCCs, etc... We even have compile time options that allow that stuff to
> be initialized before start_kernel...

Thank you. This is what I described and want to understand. The
arch/powerpc/kernel/legacy_serial.c
do find_legacy_serial_ports then take a default serial port by using
open firmware device tree
information. The find_legacy_serial_ports() called form setup_arch but
I don't know who call
setup_arch (setup_32.c)function. Can you give me a hint ? Thanks in advanced.

BRs, H. Johnny
