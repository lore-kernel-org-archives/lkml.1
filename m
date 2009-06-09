Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZFILkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZFILkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZFILkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:40:35 -0400
Received: from stinky.trash.net ([213.144.137.162]:60867 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbZFILke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:40:34 -0400
Message-ID: <4A2E4A32.1060705@trash.net>
Date: Tue, 09 Jun 2009 13:40:34 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Gil Beniamini <gil.beniamini@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>	 <20090608.143454.161329513.davem@davemloft.net>	 <4A2E4077.8080407@trash.net> <91ac27070906090427k6f57745xc72f9fcb6801957a@mail.gmail.com>
In-Reply-To: <91ac27070906090427k6f57745xc72f9fcb6801957a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gil Beniamini wrote:
> 9Jun09, The problem was seen with eth1 using driver e1000e, but also
> was reproduced on 3c59x, to me it seems that the problem is not
> related to a specific nic driver.
> VLAN is running for other NICs, but on the application specific nic
> (eth1) I use PF_PACKET (SOCK_RAW) , in order to get  the raw-packet
> from the underlying device, and this start working again (like in
> older kernel) as soon as the application set the socket to PROMISC
> mode.

OK, that might explain it. e1000e performs VLAN filtering in hardware
and unless there are VLANs configured locally, all VLANs are filtered
out. Are you seeing seeing only unicast VLAN traffic or no VLAN traffic
at all? Please post a dump of the packets with and without promiscous
mode.

