Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139Ab0AGPMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0AGPMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076Ab0AGPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:12:41 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57495 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0AGPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vP8ykKCusejzifqiW4IsJSNdJxleZi1V2ZMKWmF/Fu+G+6Kn8px1txeaEFqW5e5wsJ
         JHrPfipbVF7tRB5thMX0eT+UE/Z32ZC8dCnCJqMx96MxeOMv54uqrXUZl+rT59tdkEHr
         SvhMz6AVytcDxgbIfAmRA9G4QR5BT147uXhuA=
MIME-Version: 1.0
Date: Fri, 8 Jan 2010 00:12:40 +0900
Message-ID: <7f65365c1001070712p348c3522l1874886b0bfb80b9@mail.gmail.com>
Subject: Multicasting from kernel space.
From: Vadim Galitsyn <galitsyn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am trying to find the proper way to send multicast traffic from
kernel space at 2.6.32 kernel.
My code is like this:

/* Create a socket */
static struct socket *sock;

sock_create_kern(AF_INET, SOCK_DGRAM,
                           IPPROTO_UDP, &sock);

...

/* Set address */
struct sockaddr_in mc_addr;

mc_addr.sin_family = AF_INET;
#define MCAST_ADDR "224.1.1.1"
#define MCAST_PORT 10000
mc_addr.sin_addr.s_addr = htonl((__be32)MCAST_ADDR);
mc_addr.sin_port = htons(MCAST_PORT);

/* Prepare transfer */
struct kvec   vec;
struct msghdr msg;

vec.iov_base = buf;
vec.iov_len  = BUF_SIZE;
msg.msg_name = &mc_addr;
msg.msg_namelen = sizeof(mc_addr);
kernel_sendmsg(sock, &msg, &vec, 1, size);

I am getting error -101 (ENETUNREACH) here. But routing table is ok:

root:~> route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.1.0.0        *               255.255.255.0   U     0      0        0 eth0
224.0.0.0       *               240.0.0.0       U     0      0        0 eth0
root:~>

I am able to send multicast packets from user space in this
configuration. What's wrong with kernel space?

Thank you,
Vadim.
