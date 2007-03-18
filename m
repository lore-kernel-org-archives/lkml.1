Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbXCRG3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbXCRG3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXCRG27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:28:59 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:1421 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbXCRG26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:28:58 -0400
Message-ID: <45FCDBFA.702@jonmasters.org>
Date: Sun, 18 Mar 2007 02:28:10 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi[sz]ation Of Broken Dreams
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: Loading both the pata_atiixp and the ahci driver causes problems
References: <45F9C3F5.4070906@redhat.com> <45F9F5F0.3090508@jonmasters.org> <45FCD0FB.70507@gmail.com>
In-Reply-To: <45FCD0FB.70507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jon Masters wrote:
>> Chuck Ebbert wrote:
>>
>>> If you try to load both the pata_atiixp and the ahci driver
>>> (for the same ATI SB600 adapter), very strange things happen.
>>> The AHCI driver churns for three minutes or so, spewing
>>> messages like this, then nothing works:
>>>
>>> <6>ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> <4>ata3.00: qc timeout (cmd 0xec)
>>> <4>ata3.00: failed to IDENTIFY (I/O error, err_mask=0x104)
>>> Shouldn't it be able to tell the device has already been
>>> claimed by some other driver?
>> One would assume it'd fail to grab the PCI IO ranges twice? I haven't
>> looked at the code but I have seen this bug mentioned elsewhere so I
>> might well end up having to do that yet :-)
> 
> Dunno much about sb600 but ahci and pata_atiixp are probably using
> separate IO regions && separate PCI functions.

Yeah. I actually thought about this whole issue a bit more recently - 
things like SATA/PATA interference when you've got a part that emulates 
legacy functionality so can appear as two different kinds of device - 
since I don't think my brain was really bothering to listen before. 
Words were going in, but it chose to ignore what was being said.

Only thing that comes to mind is in-driver logic/driver loading ordering 
hack combinations. At least if you've got loadable modules, you've got a 
fighting chance of fixing this kind of situation - built-in and you need 
to fight with whatever ordering exists in the array of init functions.

Jon.

P.S. Guess this means I need to admit I was wrong and apologize to 
Zaitcev sometime too in relation to another discussion...bah :P

