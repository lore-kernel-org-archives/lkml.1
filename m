Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYAKOgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYAKOgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbYAKOgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:36:44 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:56002 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYAKOgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:36:43 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19kQoIPfsEIGVhalSflzHYY
Message-ID: <47877ECD.9060408@reed.com>
Date: Fri, 11 Jan 2008 09:35:57 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	 <47845972.9090803@zytor.com>	 <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	 <47854916.4080703@reed.com> <1200015388.6192.22.camel@bodhitayantram.eng.vmware.com> <4786DD05.20804@keyaccess.nl>
In-Reply-To: <4786DD05.20804@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rene Herman wrote:
> On 11-01-08 02:36, Zachary Amsden wrote:
>
>> FWIW, I fixed the problem locally by recompiling, changing port 80 to 
>> port 84 in io.h; works great, and doesn't conflict with any occupied 
>> ports.
>
> Might not give you a "proper" delay though. 0xed should be a better 
> choice...
>
I don't think there is any magic here.  I modified the patch to do *no 
delay at all* in the io_delay "quirk" and have been running reliably for 
weeks including the very heavy I/O load that comes from using software 
RAID on this nice laptop that has two separate SATA drives!  This 
particular laptop has no problematic devices - the only problem is 
actually in the CMOS_READ and CMOS_WRITE macros that *use* the _p 
operations in a way that is unnecessary on this machine.  (in fact, it 
would be hard to add a problematic device - there's no PCMCIA slot 
either, and so every option is USB or Firewire).

Using 0xED happens to work, but it's not guaranteed to work either.  
There is not a "standard" for an "unused port that is mapped to cause a 
bus abort on the LPC bus".   More problematic is that I would think some 
people might want to turn on the AMD feature that generates machine 
checks if a bus timeout happens.   The whole point of machine checks is 
to allow the machine to be more reliable.   Using any "unused port" for 
a delay means that the machine check feature is wasted and utterly unusable.


