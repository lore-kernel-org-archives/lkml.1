Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbXGYRMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbXGYRMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXGYRMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:12:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:1222 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXGYRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=G+Q811n3ts4yORZ8HopAk4YXTL+uwMR53ttS16nmXmgPgXCMxpr/hi8vRL5LfyovYVzebrZsxK33zQDE8QA7qo9DGDn5jiu8EOOGB0b0D7/F8i/exWG06zAVho6dOHKm7BpgyLyYZEAn27V9K+6G3Eu9lGQmh/xEQgMBhhhq+Hc=
Message-ID: <526ad3230707251012r25188175g5fa460fe90ca9d61@mail.gmail.com>
Date: Wed, 25 Jul 2007 10:12:45 -0700
From: "Siddharth Taneja" <siddharth.taneja@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: TCP MD5 and Scatter Gather offloading.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using a vanilla 2.6.22.1 kernel and I see the same kind of
problem as had been mentioned some time back on this list

http://lkml.org/lkml/2007/5/22/45

The issue is essentially that with the MD5 option enabled for the
specific TCP connection, the SYN and SYN-ACKS are passed fine and the
connection establishes fine, but the other end (a cisco router)
complains about incorrect MD5 signatures on any other message that is
sent after this.

Setting the scatter-gather offloading option on the NIC seems to
correct this problem. Recently I had seen a checkin (as a response to
the problem mentioned in the above link) where the TSO option was
turned off to make MD5 work (my kernel has that fix). Is a similar
solution needed here too?

This is the information about my system:
> uname -a
Linux stdalone 2.6.22.1 #1 SMP Mon Jul 23 20:15:21 PDT 2007 i686 i686
i386 GNU/Linux

> ethtool -i eth0
driver: e1000
version: 7.3.20-k2
firmware-version: N/A
bus-info: 0000:01:0a.0

> ethtool -k eth0
Offload parameters for eth0:
rx-checksumming: on
tx-checksumming: on
scatter-gather: off
tcp segmentation offload: off

Thanks for your help.

Siddharth

PS: I would like to be CC'ed on the reply to this email. Thanks.
