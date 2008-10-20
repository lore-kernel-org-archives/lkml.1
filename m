Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbYJTIZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbYJTIZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYJTIZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:25:22 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:44863 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYJTIZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:25:22 -0400
Message-ID: <48FC4066.9060303@motion-twin.com>
Date: Mon, 20 Oct 2008 10:25:10 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: poll() blocked / packets not received ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have an application that uses pthreads and (blocking) sockets.

When the application runs with one single thread in separate processes 
(using fork()) we don't get any problem.

However when it's multithreaded, we sometimes get stuck while poll()ing 
a socket (with events set to POLLIN). Even after the other side of the 
connection has closed its side of the connection, we are still stuck 
here. Adding a timeout only makes the poll() exit with 0, so we loop.

In case we don't loop the next operation is a recv() which will block as 
well (which is consistent).

It seems like nothing is longer received on the socket but it's 
difficult to verify with tcpdump since our server outputs something like 
15MB at peek time with 150 hits per seconds.

We have Shorewall installed and enabled, but what seems strange is that 
the problem depends on multithreading. It also occurs much more often on 
the 4 core machines than on a 2 core ones (both with Hyperthreading 
activated). We're using kernel 2.6.20-15-server (#2 SMP) provided by Ubuntu.

Any tip on we could fix that or investigate further would be 
appreciated. After one month of debugging we're really out of solution now.

Best,
Nicolas
