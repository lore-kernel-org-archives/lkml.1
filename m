Return-Path: <linux-kernel-owner+w=401wt.eu-S965145AbXC0Goa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbXC0Goa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXC0Goa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:44:30 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:16050 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145AbXC0Go3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bII9DHHSlvxq18GggZJvmPk9T1BGrNpc2i79wi9TSDJapTnCX4VewU09p64aZOjbFhNchPe5JxO66KV5eAeI3LWOXDWf5BOWMMTTnexObT91Z4tusq8dbsX6PQ5FXozRJ9FOOboyHa2ifI8aa40pmbqX/tTjbUP2JYfzY+TqH6g=
Message-ID: <6eb6ed920703262344i5eec0dfdq169c14b8da2696c9@mail.gmail.com>
Date: Tue, 27 Mar 2007 14:44:28 +0800
From: "railroad seeker" <railroad.seeker@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: About Linux Socket Filter
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I am writing a socket filter program and using "tcpdump -dd vlan and arp"
to filter out the arp packet whose protocol field is 8100(vlan). Everything
is fine if I call recvfrom to receive the packet. However, if I open two
packet socket in parallel (and use the select to demultiplex among them,
then the program will sacrifice the arp protocol handling! My program get
arp request/reply as usual, but the kernel cannot get any arp request
anymore. And the linux kernel no longer receives any packet if I flush
the arp table since kernel cannot get arp request.

I insert debug information (printk) next to the ptype handling loop,
netif_receive_skb (ret = pt_prev->func(skb, skb->dev, pt_prev)),
and the kernel exactly print out the information. Does that mean the
packet is exactly inserted into the queue of the socket and kernel path
returns to the processing loop? How could user space program steal
the packet?  (Note that the two interface involved are the member of the
bridge, but I think the ptype looping is after the handle bridge and should
not sacrifice the arp handling.)
