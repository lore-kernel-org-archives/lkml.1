Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbZFJOdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbZFJOdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbZFJOcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:32:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:59884 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487AbZFJOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:32:51 -0400
Message-ID: <4A2FC40E.4040106@trash.net>
Date: Wed, 10 Jun 2009 16:32:46 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Gil Beniamini <gil.beniamini@gmail.com>
CC: Brent Cook <bcook@bpointsys.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>	 <4A2E4A32.1060705@trash.net>	 <91ac27070906090608me50af3bv23b150d8d0cd0080@mail.gmail.com>	 <200906091430.32294.bcook@bpointsys.com> <91ac27070906100724v25c2328x6b343315358c8e12@mail.gmail.com>
In-Reply-To: <91ac27070906100724v25c2328x6b343315358c8e12@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, please don't top post.

Gil Beniamini wrote:
> My application is a "proxy" and need to support few VLANs (for example vlan 24).
> I define all vlans on interface 'eth0' which is my "out i/f", while
> the other interface 'eth1' (used as "in i/f") I use with PF_PACKET /
> SOCK_RAW in order to handle VLANs by my application (starting with
> "arp broadcast").
> When I try to define the same (relevant VLAN) on eth1 (inorder to
> check your suggestion), I get "Error: trying to add VLAN #24 to IF
> -:eth1:- error: file exist".
> It seems that linux does not allow to define the same VLAN # on more
> than a single i/f?!

No, that has got to be a mistake. You can use the same ID once
per underlying device:

# ip -d link list

4: vlan0@dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN
     link/ether d6:1f:c0:bd:b2:ec brd ff:ff:ff:ff:ff:ff
     vlan id 1000 <REORDER_HDR>
6: vlan1@dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN
     link/ether 8a:17:13:5d:87:1a brd ff:ff:ff:ff:ff:ff
     vlan id 1000 <REORDER_HDR>

If it doesn't work for you, please post the full commands
and ip -d link list output you used.
