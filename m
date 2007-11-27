Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbXK0JKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbXK0JKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXK0JKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:10:16 -0500
Received: from mout2.freenet.de ([195.4.92.92]:56653 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXK0JKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:10:14 -0500
Message-ID: <474BDEDE.6060603@de.ibm.com>
Date: Tue, 27 Nov 2007 10:09:50 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Anthony Liguori <aliguori@us.ibm.com>,
       Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com> <4747051C.3090903@us.ibm.com> <4747122F.1070905@qumranet.com> <474B1BF3.20901@us.ibm.com> <474BDD28.7050801@qumranet.com>
In-Reply-To: <474BDD28.7050801@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> No, definitely not define a hypercall ABI.  The feature bit should say 
> "this device understands a hypervisor-specific way of kicking.  consult 
> your hypervisor manual and cpuid bits for further details.  should you 
> not be satisfied with this method, port io is still available".
...unless you're lucky enough to be on s390 where pio is not available.
I don't see why we'd have two different ways to talk to a virtio 
device. I think we should use a hypercall for interrupt injection, 
without support for grumpy old soldered pci features other than 
HPA-style Lguest PCI bus organization. There are no devices that we 
want to be backward compatible with.
