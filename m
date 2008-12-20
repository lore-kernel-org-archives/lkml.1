Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYLTDSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYLTDSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 22:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYLTDSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 22:18:38 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:8698 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYLTDSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 22:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FuKzaGoKWAJtsAEuj8535RB80Z+vtyZ0ce6q3HXm/2A+HY9ObeXi0apKadmg2kW0Th
         /1g3fHdNQnUASjVnUPdKXusfWMmVRQvLBwfuPN9kd3h8YQjlmac9ErXlFM2pbUqjx6io
         f6owG0LShqvZXkyPnOm/Wvf/bYrB6yQiSw0DM=
Message-ID: <e33b34250812191918t5d139c32qe0f1f6e56a887ceb@mail.gmail.com>
Date: Sat, 20 Dec 2008 11:18:36 +0800
From: "Kenneth Zhu" <ipiv.ipvi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [IPv6] kernel_sendmsg returned -101 to kernel module for some multicast destination
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been trying to send all sorts of IPv6 packets in my kernel
module and most of them succeeded, while when I want to
send to some special address -- ff02::d in my case --
kernel_sendmsg returned me a -101 error code which means
"Network Unreachable". Compared to similar application layer
implementation like ping6, I find it also reports an error when
the outbound interface is not specified.

This is part of my source code regarding this error, while I think
I have specified the outbound interface (mcast_oif). Is anybody
knows where the problem is?

       sock->sk->sk_allocation = GFP_NOIO;

       inet = inet_sk(sock->sk);
       inet->num = ip6h->nexthdr;
       inet->hdrincl = 1;

       np = inet6_sk(sock->sk);
       np->sndflow = 0;
       np->daddr = ip6h->daddr;
       np->saddr = ip6h->saddr;
       np->hop_limit = ip6h->hop_limit;
       np->mcast_oif = v6index;

       sin.sin6_family = PF_INET6;
       sin.sin6_addr = ip6h->daddr;
       sin.sin6_port = htons(ip6h->nexthdr);

       iov.iov_base = data;
       iov.iov_len = pktlen;
       msg.msg_name = &sin;
       msg.msg_namelen = sizeof(sin);
       msg.msg_control = NULL;
       msg.msg_controllen = 0;
       msg.msg_flags = MSG_NOSIGNAL;

       kernel_sendmsg(sock, &msg, &iov, 1, pktlen);

Thank you very much!

Best regards,

Kenneth. Z
