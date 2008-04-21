Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbYDURnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbYDURnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYDURng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:43:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbYDURnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:43:35 -0400
Message-ID: <480CD178.2070806@zytor.com>
Date: Mon, 21 Apr 2008 13:40:08 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Frantisek Rysanek <Frantisek.Rysanek@post.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: What pokes the ISA IO port of 0x211 ?
References: <480C92C9.18283.A24BB91B@localhost> <e2e108260804210851j5cd86901r37f65190fac8a024@mail.gmail.com>
In-Reply-To: <e2e108260804210851j5cd86901r37f65190fac8a024@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Mon, Apr 21, 2008 at 1:12 PM, Frantisek Rysanek
> <Frantisek.Rysanek@post.cz> wrote:
>>  I'm dealing with an embedded PC motherboard that contains some custom
>>  circuitry (GPIO), accessible via an ISA IO range between 0x200 and
>>  0x218.
>>
>>  There's an interesting issue with this in recent Linux (tried
>>  2.6.22.6 and 2.6.24.2): something probes IO port 0x211 on boot, which
>>  happens to be an add-on buzzer control port - effectively the kernel
>>  boot launches an accoustic alarm :-)
>>
>>  Any ideas what this could be?
> 
> Did you already have a look at /proc/ioports ? This file should
> contain every range of ISA bus address in use by any kernel component.
>

This might not be the case if a probe fails and the driver unload 
itself.  It might be easiest to put in a hack in the kernel by hacking 
outb/outw/outl and print stack trace when called when trying to poke 
this port.

For what it's worth, this port is specified as "Game Blaster" in the 
Interrupt List.

	-hpa


