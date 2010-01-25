Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790Ab0AYXF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0AYXF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580Ab0AYXFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:05:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46316 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0AYXFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:05:54 -0500
Message-ID: <4B5E23BB.1090806@zytor.com>
Date: Mon, 25 Jan 2010 15:05:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>, Robert Hancock <hancockrwd@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain> <4B57A2D4.9030204@gmail.com> <20100121185544.GB11996@core.coreip.homeip.net> <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com> <20100121221701.GA15293@core.coreip.homeip.net> <20100125163433.GB31957@suse.cz> <4B5E0DFA.8080705@zytor.com> <20100125221520.GA30307@core.coreip.homeip.net> <4B5E18C0.7060402@zytor.com> <20100125223004.GB30307@core.coreip.homeip.net>
In-Reply-To: <20100125223004.GB30307@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 02:30 PM, Dmitry Torokhov wrote:
>>
>> We should never read from port 0x60 unless bit 1 in port 0x64 is set.
>> Do we do that?
> 
> No, we don't read of OBF is 0. Incidentially 0xff has it set ;) so we do
> try reading data port.
> 

What do you do after reading the data port?  In the case of the A20
code, we do dummy reads and loop until the data port drains (0xff of
course means it never drains...)

Note that it is quite likely the A20 code never gets exercised on Apple
boxes, since we only run it if A20 is disabled on entry, *and* the BIOS
doesn't implement INT 15h AX=2401h.

	-hpa
