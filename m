Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbYHMHk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbYHMHk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYHMHkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:40:13 -0400
Received: from main.gmane.org ([80.91.229.2]:50908 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYHMHkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:40:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Daniel Ng <daniel_ng11@lycos.com>
Subject: Multicast socket behaviour?
Date: Wed, 13 Aug 2008 07:39:37 +0000 (UTC)
Message-ID: <loom.20080813T072943-582@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 124.190.96.129 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below C code registers the socket with the multicast group 'HELLO_GROUP':

    mreq.imr_multiaddr.s_addr=inet_addr(HELLO_GROUP);
    mreq.imr_address.s_addr=htonl(INADDR_ANY);

    mreq.imr_ifindex = if_nametoindex("ppp1");

    if (setsockopt(fd,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof(mreq)) < 0) {
        perror("setsockopt");
        exit(1);
    }

I understand that if 'INADDR_ANY' is used, it is up to the kernel to decide 
what action to take.

>From my experiments, it seems that the interface corresponding to the 
highest '224.0.0.0' entry in the routing table is used.

Would someone please explain why this is so? 

How difficult would it be to have the kernel join the HELLO_GROUP on *all* 
available multicast-capable interfaces? Why isn't this currently implemented?

I'm using 2.6.14.

Cheers,
Daniel


