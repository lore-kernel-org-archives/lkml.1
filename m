Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZFDPBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZFDPBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZFDPB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:01:26 -0400
Received: from smtp-ha02.de.mxcluster.de ([193.200.237.58]:51169 "EHLO
	smtp-ha02.de.mxcluster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZFDPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:01:25 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 11:01:25 EDT
Date: Thu, 4 Jun 2009 16:53:47 +0200
From: Philipp Reh <sefi@s-e-f-i.de>
To: linux-kernel@vger.kernel.org
Subject: When does Linux drop UDP packets?
Message-ID: <20090604145347.GA27692@miyuki>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

I have the following setting in which a client that resides on the same
physical network as a server wants to receive any UDP packet that
arrives on any of its interfaces sent by that server.

The code sets the broadcast flag, calls bind to INADDR_ANY and
uses recvfrom from there on.

Let's say the server resides in the subnet 192.168.6.255 and the
client in 192.168.3.255. The server uses its real IP as the packet's
sender ip (192.168.6.5).

Now the first problem I've encountered is the following:
If the client removes its default route and doesn't have any route
pointing into the subnet the server is in, the packets get discarded
(still tcpdump sees them).

The second problem is that if the server uses the broadcast address as
its sender address (255.255.255.255), the packets get always discarded
(again, tcpdump sees them).

Now if the server fakes its sender address to be in the client's subnet,
every packet arrives again.

So my real question is:
When does Linux discard packets and how can I prevent it from doing
that?

As I'm not yet subscribed to the list, please CC me directly.

Cheers,
Philipp

