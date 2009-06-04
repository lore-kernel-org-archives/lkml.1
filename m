Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZFDP5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZFDP5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZFDP5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:57:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZFDP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:57:41 -0400
Date: Thu, 4 Jun 2009 11:57:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Philipp Reh <sefi@s-e-f-i.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090604155741.GA8999@goodmis.org>
References: <20090604145347.GA27692@miyuki>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604145347.GA27692@miyuki>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:53:47PM +0200, Philipp Reh wrote:
> Dear list,
> 
> I have the following setting in which a client that resides on the same
> physical network as a server wants to receive any UDP packet that
> arrives on any of its interfaces sent by that server.
> 
> The code sets the broadcast flag, calls bind to INADDR_ANY and
> uses recvfrom from there on.
> 
> Let's say the server resides in the subnet 192.168.6.255 and the
> client in 192.168.3.255. The server uses its real IP as the packet's
> sender ip (192.168.6.5).

You don't say what the client IP is. Let's assume that it is 192.168.3.1
for simplicity.

> 
> Now the first problem I've encountered is the following:
> If the client removes its default route and doesn't have any route
> pointing into the subnet the server is in, the packets get discarded
> (still tcpdump sees them).
> 

Are you saying that the server sent to 192.168.3.1 with source ip of
192.168.6.5 and the client did not see it?

> The second problem is that if the server uses the broadcast address as
> its sender address (255.255.255.255), the packets get always discarded
> (again, tcpdump sees them).

Again, what was the destination IP address?

> Now if the server fakes its sender address to be in the client's subnet,
> every packet arrives again.

So the only thing you change is the sender address?

What tools are you using to read the packets, and how do you know it is
dropped?

-- Steve

> 
> So my real question is:
> When does Linux discard packets and how can I prevent it from doing
> that?
