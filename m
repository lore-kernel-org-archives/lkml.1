Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYFSKd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYFSKd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbYFSKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:33:10 -0400
Received: from kuber.nabble.com ([216.139.236.158]:51522 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYFSKdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:33:09 -0400
Message-ID: <18005751.post@talk.nabble.com>
Date: Thu, 19 Jun 2008 03:33:09 -0700 (PDT)
From: SHUperb <lin.en.shu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IP layer send packet
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Nabble-From: lin.en.shu@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi kernel experts,

I’m trying to modify the IP packet src & dest address after receiving from
the wire and reconstruct the packet at kernel layer without going to apps
layer and ultimately send out the packet. So, the recommended API to be used
is ip_finish_output() (as it is the only exported symbol to send UDP
packets). However, since the IP header content are changed, the system must
automatically recalculate checksum and needs mac address as well, and most
of the time mac address of unknown hosts.

Currently, when I try, I need to invoke mac address resolution via arp by
manually calling neigh_lookup of existing arp entry before sending the
packet by calling dev_queue_xmit(). 

My questions is how can I change (dest/src IP and port number) at before
ip_finish_output() by accessing specific struct should I want to send the
packet to unknown hosts (unknown means remote hosts that do not have an arp
entry in local host's arp table) by calling ip_finish_output().

Thank you very much for your advice.

-- 
View this message in context: http://www.nabble.com/IP-layer-send-packet-tp18005751p18005751.html
Sent from the linux-kernel mailing list archive at Nabble.com.

