Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXDPVpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXDPVpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXDPVpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:45:22 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:56313 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXDPVpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:45:22 -0400
To: linux-kernel@vger.kernel.org
Subject: bug in tcp?
Date: Mon, 16 Apr 2007 15:45:19 -0600
From: Sebastian Kuzminsky <seb@highlab.com>
Message-Id: <E1HdZ0h-0001go-RK@highlab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing some weird behavior in TCP.  The issue is perfectly
reproducible using netcat and other programs.  This is what I do:

    1.  Open a TCP connection over the loopback (over IPv4).

    2.  Send a couple of bytes of data each way.  No problems.

    3.  Wait about 120 hours with no writes on either side of the
        connection.

    4.  write() a few bytes to the server's socket.  I'd expect the data
        to go through, but it doesnt.  I see the TCP frame from the
        server to the client, but instead of an ACK, the client sends
        back a RST.  netstat shows the bytes sitting in the server's
        socket's send-buffer.

    5.  write a few bytes to the client's socket.  The server gets
        these immediately.

    6.  On the next server-to-client retransmit, the client gets the
        bytes from the server.  After this, the connection works normally.


The libpcap capture file is here:  http://highlab.com/~seb/tcp-idleness-bug


The behavior is reproducible on all kernels I've tried: 2.4.32, 2.6.19.1,
and 2.6.20.4.  I dont think it's iptables-related, though I'm rerunning
the tests on a machine without iptables to be sure.  I'll have results
for you in 120 hours.  ;-)


-- 
Sebastian Kuzminsky
