Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbZFINOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbZFINOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZFINOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:14:33 -0400
Received: from stinky.trash.net ([213.144.137.162]:62834 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZFINOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:14:33 -0400
Message-ID: <4A2E6039.2060805@trash.net>
Date: Tue, 09 Jun 2009 15:14:33 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Gil Beniamini <gil.beniamini@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>	 <20090608.143454.161329513.davem@davemloft.net>	 <4A2E4077.8080407@trash.net>	 <91ac27070906090427k6f57745xc72f9fcb6801957a@mail.gmail.com>	 <4A2E4A32.1060705@trash.net> <91ac27070906090608me50af3bv23b150d8d0cd0080@mail.gmail.com>
In-Reply-To: <91ac27070906090608me50af3bv23b150d8d0cd0080@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't top-post.

Gil Beniamini wrote:
> On the specific NIC (eth1) no vlan is defined, and in the new Linux
> the application receive NOTHING at all. In order to debug, I start
> "wireshark as root" and "wireshark" set PROMISC on, and the
> application start receive the raw packets as expected. Later I started
> setting PROMISC by my application, and it can receive the packets even
> when "wireshark" is not running.
> The problem that I have with PROMISC mode, is that I need to do the
> irelevant  unicast filtering in software rather than get it from the
> hardware (as it works in old kernel 2.6.20).

in older kernels the hardware filtering was inconsistent. Some drivers
behaved as today, meaning they filtered out all VLANs unless locally
configured, some filtered nothing until the first VLAN was added,
at which point they would filter all other VLANs (and maybe enable
header stripping).

The behaviour you describe is intended, only locally configured VLANs
are received unless you switch to promiscous mode.
