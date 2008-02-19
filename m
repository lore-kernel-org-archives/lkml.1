Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbYBSNxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbYBSNxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYBSNxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:53:36 -0500
Received: from raffaello.crs4.it ([156.148.72.33]:47874 "EHLO
	raffaello.crs4.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYBSNxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:53:35 -0500
From: Omar Schiaratura <omar@crs4.it>
To: linux-kernel@vger.kernel.org
Subject: sun neptune driver
Date: Tue, 19 Feb 2008 14:53:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Organization: CRS4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191453.35210.omar@crs4.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
i'm trying to write a back-porting of the Sun neptune NIC driver(niu module) in kernel 2.6.24 to the kernel 2.6.20
because i need that driver in a xen linux environment.
The driver now compile and goes up clearly, NIC is configured, but doesn't work properly.
If i send packets to another machine with the same NIC and kernel 2.6.24,I saw with tcpdump that the packets was received and the answer was sent,
but at the other end (kernel 2.6.20 with my backported driver, and without XEN) nothing appens (tcpdump report sent packages, but i can't see anything sent from other side)
Do you have some tricks for me or can you suggest me something to do?

Some of the problem i encountered during port is that i can't find a function equivalent to compound_head, and if i port it to the source i can't find a way to use
an equivalent variable like page->first_page found in compound_head.
another proble was the folowing function:

static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
{
        return (unsigned char *)((unsigned int)skb->head + (unsigned int)skb->h.raw);
}

that get the error: "error: invalid operands to binary +"
if i can't cast it in unsigned int, the same in skb_network_header (both back-ported from include/skbuff.h)

thanks,
Omar
