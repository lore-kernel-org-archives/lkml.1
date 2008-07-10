Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYGJNbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYGJNbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYGJNb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:31:29 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:39772 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYGJNb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:31:28 -0400
Message-ID: <48760ECF.1060103@hiramoto.org>
Date: Thu, 10 Jul 2008 15:29:51 +0200
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org
Subject: nfs root error after modprobe iptable_nat
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

loading nf_nat seems to cut my NFS root connection.

# modprobe iptable_nat
nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
nfs: RPC call returned error 1
nfs: RPC call returned error 1
# nfs: RPC call returned error 1
nfs: RPC call returned error 1



12:23:35.335832 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
UDP (17), length 136) 192.168.10.54.4259114599 > 192.168.10.51.2049: 108
lookup [|nfs]
12:23:35.335920 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
UDP (17), length 56) 192.168.10.51.2049 > 192.168.10.54.4259114599:
reply ok 28 lookup ERROR: No such file or directory
12:23:35.336611 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
UDP (17), length 136) 192.168.10.54.4259114600 > 192.168.10.51.2049: 108
lookup [|nfs]
12:23:35.336650 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto
UDP (17), length 56) 192.168.10.51.2049 > 192.168.10.54.4259114600:
reply ok 28 lookup ERROR: No such file or directory



NFS server:
uname -a
Linux karl-d820 2.6.25.10 #1 SMP Thu Jul 10 10:15:44 CEST 2008 i686
Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz GenuineIntel GNU/Linux



NFS Client:
# uname -a
Linux NSB 2.6.25.10 #6 Thu Jul 10 13:04:15 CEST 2008 armv5teb unknown
uclibc 0.29
Intel  IXP425


On the server there are no error messages.  without loading NAT 
everything seems to work fine.


Comping NAT directly into the kernel also has the same results.


Not sure if i have something configured wrong, or if this is related to 
the patches sent by Trond a few days ago.

Thanks,
Karl
