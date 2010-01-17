Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0AQSWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0AQSWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294Ab0AQSWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:22:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51408 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752911Ab0AQSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:22:15 -0500
Date: Sun, 17 Jan 2010 18:25:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michael Stone <michael@laptop.org>,
       Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: disablenetwork (v5): Simplify the disablenetwork sendmsg hook.
Message-ID: <20100117182500.4938bb88@lxorguk.ukuu.org.uk>
In-Reply-To: <20100117180405.GA32339@redhat.com>
References: <20100117161053.GG3420@redhat.com>
	<20100117170431.GA2949@heat>
	<20100117180405.GA32339@redhat.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> are all to be permitted but that calls like
> >>>
> >>>    sendto(fd, buffer, len, 0, (struct sockadr *) &addr, sizeof(addr));
> >>>
> >>> are to be rejected when the current task's network is disabled on the grounds
> >>> that the former calls must use previously connected sockets but that the latter
> >>> socket need not have been previously connected.

Not surprised to see this "simple" idea is unsurprisingly turning
incredibly complex, full of policy and also holes. Can people now accept
that the reason we have rather more complex models for security policy is
because generally speaking these "oh so simple" little magic switches
don't actually work or solve any real world problems.

And just to point out further problems - there are numerous cases where I
can control the remote destination of messages without using sendto or
passing addresses in obvious manners. You'll need to parse all the ioctls
and protocol specific calls as a starter. You'll also need a policy
engine of some form to detect when I can use send stuff in one socket I
have rights to in order to influence routing of another by talking to
network stuff or emitting controlling messages of any form.

(and even then there are tons of cases you can't fix that way as the
early Java people found to their cost. Things like connecting to a web
server via a socket that can only connect to port 80 and issuing proxy
requests, or triggering a remote carefully placed cgi script to produce
tunnels with total control.

Alan
