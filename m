Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXCRVWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXCRVWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXCRVWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:22:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbXCRVWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:22:35 -0400
Message-ID: <45FDAD74.9010402@redhat.com>
Date: Sun, 18 Mar 2007 17:21:56 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: Loading both the pata_atiixp and the ahci driver causes problems
References: <45F9C3F5.4070906@redhat.com> <45F9F5F0.3090508@jonmasters.org> <45FCD0FB.70507@gmail.com>
In-Reply-To: <45FCD0FB.70507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
> 
> Conke, care to educate us a bit here?
> 

The really funny part is that it works for some if they use:

  pci=noacpi,irqpoll


