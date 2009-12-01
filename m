Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZLAQTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZLAQTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZLAQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:18:59 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43350 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZLAQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:18:59 -0500
Message-ID: <4B15416A.2060202@nortel.com>
Date: Tue, 01 Dec 2009 10:16:42 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: seeing strange values for tcp sk_rmem_alloc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2009 16:19:02.0805 (UTC) FILETIME=[FF107450:01CA72A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm hoping someone might be able to explain some odd behaviour that I'm
seeing.

Some of our developers wanted to be able to see how much of their rx
socket buffer space was in use, so I added the following to sock_ioctl()


		case SIOCGSKRMEMALLOC:
		{
			int tmp;
			err = -EINVAL;
			if(!sock->sk)
				break;
			tmp = atomic_read(&sock->sk->sk_rmem_alloc);
			err = copy_to_user(argp, &tmp, sizeof(tmp));
			break;
		}

To validate it, I wrote a testcase that opened a tcp socket, then looped
sending 2k of data at a time to it and calling the above ioctl to check
the sk_rmem_alloc value (without ever reading from the socket).

The results were odd--I've copied them below.  Can anyone explain how I
can send 20K of data but sk_rmem_alloc still only shows 4.8K used, then
it suddenly jumps by a lot on the next packet to something that more
reflects reality, then repeats that pattern again?  Is there some
additional buffering happening somewhere in the TCP stack?

Thanks,

Chris

used: 2424
used: 4848
used: 4848
used: 4848
used: 4848
used: 4848
used: 4848
used: 4848
used: 4848
used: 4848
used: 23696
used: 23696
used: 23696
used: 23696
used: 23696
used: 23696
used: 23696
used: 23696
used: 23696
used: 42544
used: 42544
used: 42544
used: 42544
used: 42544
used: 42544
used: 42544
used: 42544
used: 42544
used: 61392
used: 61392
used: 61392
used: 61392
used: 61392
used: 61392
used: 61392
used: 61392
used: 61392
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240
used: 80240


