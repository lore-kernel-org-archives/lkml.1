Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbZFINIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbZFINIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZFINID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:08:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16168 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbZFINIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I2Fi7JdKMdY/FHjTptNKlfbFFFznqANP4WelWj0ZNvlvsa6joEvivfC1/AzjuyxhvU
         3oep+j8ib+t5RIIdJpB02GSYimx5reDLWY+yVU0w9lix8i8ZGY2sDmW/Ian7x+lpIUA/
         wh5iYeQL/gdRsxUSBeRcVwLQGOvwgbHRKwbR4=
MIME-Version: 1.0
In-Reply-To: <4A2E4A32.1060705@trash.net>
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
	 <20090608.143454.161329513.davem@davemloft.net>
	 <4A2E4077.8080407@trash.net>
	 <91ac27070906090427k6f57745xc72f9fcb6801957a@mail.gmail.com>
	 <4A2E4A32.1060705@trash.net>
Date: Tue, 9 Jun 2009 16:08:01 +0300
Message-ID: <91ac27070906090608me50af3bv23b150d8d0cd0080@mail.gmail.com>
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
From: Gil Beniamini <gil.beniamini@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick,
On the specific NIC (eth1) no vlan is defined, and in the new Linux
the application receive NOTHING at all. In order to debug, I start
"wireshark as root" and "wireshark" set PROMISC on, and the
application start receive the raw packets as expected. Later I started
setting PROMISC by my application, and it can receive the packets even
when "wireshark" is not running.
The problem that I have with PROMISC mode, is that I need to do the
irelevant  unicast filtering in software rather than get it from the
hardware (as it works in old kernel 2.6.20).
Thanks a lot, Gil

On Tue, Jun 9, 2009 at 2:40 PM, Patrick McHardy<kaber@trash.net> wrote:
> Gil Beniamini wrote:
>>
>> 9Jun09, The problem was seen with eth1 using driver e1000e, but also
>> was reproduced on 3c59x, to me it seems that the problem is not
>> related to a specific nic driver.
>> VLAN is running for other NICs, but on the application specific nic
>> (eth1) I use PF_PACKET (SOCK_RAW) , in order to get  the raw-packet
>> from the underlying device, and this start working again (like in
>> older kernel) as soon as the application set the socket to PROMISC
>> mode.
>
> OK, that might explain it. e1000e performs VLAN filtering in hardware
> and unless there are VLANs configured locally, all VLANs are filtered
> out. Are you seeing seeing only unicast VLAN traffic or no VLAN traffic
> at all? Please post a dump of the packets with and without promiscous
> mode.
>
>
