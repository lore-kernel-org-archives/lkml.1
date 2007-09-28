Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbXI1Jrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbXI1Jrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbXI1Jrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:47:42 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:8422 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbXI1Jrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HlxT7HpcZMjLpBNF/xcxu6n/sxH62la2MJmeK6KqLNvS4GoOmE3YlCvt4X+/DJgIpwxxVLMO5n1crjpiF9Y5mApLexmqsmowDPd0cEb6hMBEIMSZZkci6hBXrOOcGXhHO1vbyJqrJNdG3XshHdnZ0BSEATmHQ2u6CAONMQs3J68=
Message-ID: <46FCCD57.2020507@gmail.com>
Date: Fri, 28 Sep 2007 02:45:59 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: solari@df.uba.ar, hgsolari@gmail.com
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
References: <46FC4384.7080607@df.uba.ar>
In-Reply-To: <46FC4384.7080607@df.uba.ar>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[restoring LKML and cc'ing linux-ide and linux-acpi]

Hernan Gustavo Solari wrote:
>     I am replying directly to you since, finding that most of the
> material in the kernel list is well beyond my understanding, I cancelled
> my subscription.
> 
>     You can forward as much of my replies to the list as you think it suits

You don't have to be subscribed to the list.  Just keep them cc'd.

>> Can you set up netconsole and collect the kernel log from the failing
>> boot and post it here?
> 
> Let me first update you on the issue. I installed the kernel 2.6.22.8
> when it was the latest stable release (today stable release is 2.6.22.9)
> Trying to reproduce the problem with this kernel I get a crash but
> different from that in the 2.6.22 kernel.
> 
> The kernel is compiled as it comes, with AMD64 generic option set and
> the small systems option set by me.
> 
> With acpi=off it runs.
> With acpi=on crashes after lines
> aer: probe of 0000:00:04.0:pcie01 failed with error 2
> aer: probe of 0000:00:05.0:pcie01 failed with error 2
> aer: probe of 0000:00:06.0:pcie01 failed with error 2
> aer: probe of 0000:00:07.0:pcie01 failed with error 2
> 
> With acpi=ht runs and complaints saying
> aerinit_init: AER service init fails - No ACPI _05C support
> aer: probe of 0000:00:04.0:pcie01 failed with error 1
> and the same message for the other probes.
> 
> The next line is:
> Real Time clock driver v1.12ac
> Linux agpgart interface v0.102 (c) Dave Jones
> Serial: 8250/16550 driver ....
> 
> 
> I have filled a ticket with respect to the ACPI problems, much of them
> can be avoided disabling part of the ACPI system.
> 
> Options: I can compile the 2.6.22 kernel to get the reported problem
>      or try to debug the problem in 2.6.22.8 or something else it
>       fits the kernel-team.
> 
> With respect to netconsole, the kernel parameter would be
> netconsole=[src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
> According to
> http://www.mjmwired.net/kernel/Documentation/networking/netconsole.txt
> and based on kernel 2.6.22.1
> 
> and I cannot figure out what is [tgt-macaddr] "ethernet MAC address for
> logging agent (broadcast)"
> is it Internet Hardware address? (here
> Ethernet  HWaddr 00:0E:A6:5F:13:B2 ) or something else I cannot imagine?

Yes, correct, ethernet hardware address.  Things surrounded by brackets
are optional, BTW.

> PS: using netconsole may take me a few days since I do not have a
> network at home, I have to find the network at work available.

I see.  If you have access to a second machine, you can connect the two
directly.

Thanks.

-- 
tejun
