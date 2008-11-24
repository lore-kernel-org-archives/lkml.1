Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYKYAMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYKYAMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYKYAMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:12:37 -0500
Received: from castle.comp.uvic.ca ([142.104.5.97]:46314 "EHLO
	castle.comp.uvic.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbYKYAMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:12:37 -0500
X-Greylist: delayed 1564 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 19:12:36 EST
Message-ID: <42413.142.104.193.193.1227570383.squirrel@wm3.uvic.ca>
Date: Mon, 24 Nov 2008 15:46:23 -0800 (PST)
Subject: adaptive mode in Linux bonding driver
From: "luming" <luming@uvic.ca>
To: linux-kernel@vger.kernel.org
Cc: pan@uvic.ca
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-UVic-Virus-Scanned: OK - Passed virus scan by Sophos (sophie) on castle
X-UVic-Spam-Scan: castle.comp.uvic.ca Not_scanned_NOT_SA_HOST
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am currently working on my project which includes some modification to
the kernel bonding driver. I have created a new mode in which each ip
packet will be acknowledged by a linklayer acknowledgment. This ack will
trigger the sender to increase a counter and when the sender send out
packets, it will decrease the SAME counter.

To implement this , I have defined the counter in the structure slave. I
have registered to receive ip packet and ack packets. The problem we found
is when we bond two links (100Mbps) together with this mode, the sending
rate never go above 107Mbps. It seems something slows down the sending
rate. After some investigation, we  found that if we access the same
counter in both the sending function and the receiver handler, this
problem will happen. If we only access this counter in one of these two
functions, it will be fine. If we decrease the link bandwidth or the ack
sending frequency, we will see the sending rate increasing. So we think may
be too many acks coming in a very short time that cause too many
interrupts and slow down the system.
(We are using PIII 700MHz with linux 2.6.15-7)

My question is do you know what causes this problem and how can it be solved?
Thanks very much!
I am not subscribed in the list so please reply me back at: luming@uvic.ca.

Thanks
Ming



