Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbZG2IY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbZG2IY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZG2IY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:24:28 -0400
Received: from blu0-omc1-s22.blu0.hotmail.com ([65.55.116.33]:62821 "EHLO
	blu0-omc1-s22.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbZG2IY1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:24:27 -0400
Message-ID: <BLU141-W7E99313C2CA3BE069EC5DD4120@phx.gbl>
X-Originating-IP: [198.62.10.11]
From: manu gautam <manugautam25@hotmail.com>
To: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: FW: System Hang while trying to send over TCP socket with very less
 free m/m
Date: Wed, 29 Jul 2009 13:54:27 +0530
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Jul 2009 08:24:27.0416 (UTC) FILETIME=[FCC62980:01CA1025]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am running 2.6.12 kernel with kernel PREEMPTION being OFF. 
While sending data over TCP socket I am experiencing system hang. What is happening actually is that the system is low in free memory and the sk_stream_alloc_pskb call in tcp_sendmsg fails and the control goes to "sk_stream_wait_memory" function. Inside this function we are calling schedule_timeout only if "sk_stream_memory_free(sk) && vm_wait" check is false. In my case what happens is that this check is always true and we don't do schedule_timeout which results in the system hang.
With preemption being OFF it becomes a kind of deadlock where the one thread is waiting for the memory to be freed but it is not getting scheduled out. 

I also checked on the latest kernel but there also I dont see any fix for this issue. 

Please excuse me if I have pasted it to some wrong mailing list.
Regards,Manu
_________________________________________________________________
Missed any of the IPL matches ? Catch a recap of all the action on MSN Videos
http://msnvideos.in/iplt20/msnvideoplayer.aspx