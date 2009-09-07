Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZIGIZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZIGIZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZIGIZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:25:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZIGIZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:25:43 -0400
Message-ID: <4AA4C338.1040706@redhat.com>
Date: Mon, 07 Sep 2009 10:24:24 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, Olaf.Dabrunz@gmx.net, ktokunag@redhat.com,
       tglx@linutronix.de, lenb@kernel.org
Subject: Re: [RFC][PATCH 0/2] boot interrupts on Intel X58 and 55x0
References: <20090904165525.26294.31112.sendpatchset@t500> <20090907013328.GA19670@khazad-dum.debian.net>
In-Reply-To: <20090907013328.GA19670@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.2009 03:33, Henrique de Moraes Holschuh wrote:
> On Fri, 04 Sep 2009, Stefan Assmann wrote:
>> is more serious namely the onboard NIC (8086:10c9) is malfunctioning on some
>> of our test system if the second patch is applied. It fails to acquire an IP
>> from DHCP and we're pretty clueless on this issue right now.
>> Help is greatly appreciated!
> 
> Did you read Intel documet 320839-009, August/2009, already?  It is at:
> http://www.intel.com/Assets/PDF/specupdate/320839.pdf
> 
> I see some stuff there that might be a problem, many of the "issues" are
> related to interrupt handling.  Errata 40 (EOI to IOAPIC can be blocked)
> even states that one should avoid the X58 IOH IOAPIC on stepping B2
> completely, and use the IOAPIC in the ICH10R instead.

Hi Henrique,

good catch, I missed the errata. After reading the details of errata 40
I assume that it's not directly related because the onboard NIC is
connected to the IOH IO-APIC in the first place. No interaction with
another IO-APIC should be involved. The second reason why it's most
likely unrelated is that it only happens when booted with pci=nomsi
(should have mentioned that earlier, sorry) and the errata states:
"The End of Interrupt (EOI) message targeted to the I/OxAPIC will be
blocked in the case that an INTx from a PCIe device and an MSI are
pending inside the Intel X58 Express Chipset."

I've also looked through the other errata and while some of them look
pretty wild I couldn't find anything that might be the root cause for
the observed problem. Same goes for the 55x0 August/2009 spec update.
http://www.intel.com/Assets/PDF/specupdate/321329.pdf

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
