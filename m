Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYJTXWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYJTXWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYJTXWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:22:09 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4590 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYJTXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:22:08 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <ncannasse@motion-twin.com>
Cc: <swivel@shells.gnugeneration.com>, <linux-kernel@vger.kernel.org>
Subject: RE: poll() blocked / packets not received ?
Date: Mon, 20 Oct 2008 16:21:11 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEMEAIAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <48FCBEBE.700@motion-twin.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 20 Oct 2008 16:23:13 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 20 Oct 2008 16:23:14 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I agree with both points, but I can't modify the MySQL protocol to
> implement that.

> For (1) I can't add the timeout since I have no way to differentiate
> between a lost connection and a request that takes time to execute. I'll
> maybe check if the protocol allow pings while waiting for the request
> result, but I'm not sure it does.

Sure you can. For example, you can run a proxy on both the server and the
client, with the two proxies speaking a protocol that carries the MySQL
protocol. The protocol between the server and the client can include two
types of messages, one being regular data (which the proxies pass to the
server and client software) and one being a ping (which the proxies use
internally to decide when to drop their connections). Each proxy can 'ping'
the other as often as required and drop both connections if the ping fails
to go through. This will ensure that your program detects a connection loss
rapidly.

There are many other possible solutions.

> For (2) the shared resources is on the database side, not on the server
> side. It's the transaction that have some rows locked. I have no
> solution for that.

That doesn't fit your problem description. Presumably the server detected
the loss of the connection and so would have released any resources it was
holding that were associated with it. The problem in this case was that the
client couldn't detect the loss of the connection.

> Best,
> Nicolas

Good luck.

DS


