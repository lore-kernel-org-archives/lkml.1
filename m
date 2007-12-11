Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbXLKMIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbXLKMIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 07:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXLKMIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 07:08:43 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37148 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbXLKMIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 07:08:42 -0500
Message-ID: <475E7DC2.4060509@davidnewall.com>
Date: Tue, 11 Dec 2007 22:38:34 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Paul Rolland <rol@as2917.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl>
In-Reply-To: <475E5D4B.8020101@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 11-12-07 08:40, Paul Rolland wrote:
>
>> Well, if the delay is so much unspecified, what about _reading_ port 
>> 0x80 ?
>> Will the delay be shorter ?
>
> The delay is completely and fully specified in terms of the ISA/LPC clock

That would be the delay on the i386 (sic) architecture.  In general, 
though, the delay is:

    "Some devices require that accesses to their ports are slowed down. 
    This functionality is provided by appending a _p to the end of the
    function."
    -- Documentation/DocBook/deviceiobook.tmpl


(I've not seen any other formal definition.)

Most architectures (Alpha, Arm, Arm2, Blackfin, FRV, h8300, IA64, 
PA-RISC, PowerPC, Sparc, Sparc64, V850 and Xtensa) do no pause.  M68k 
does no pause except in one configuration, when it's the same as i386.  
On m32r it's a push and a pop.  On SuperH it's similar to i386, only 
using 16-bit input.  X86-64 is the same as i386!

Thinking that _p gives a pause is perhaps too PC-centric.  Why, if a 
delay is needed, wouldn't you use a real delay; one that says how long 
it should be?
