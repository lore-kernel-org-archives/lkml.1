Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZFKXqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZFKXqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZFKXqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:46:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:18618 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZFKXqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:46:47 -0400
Date: Thu, 11 Jun 2009 16:40:44 -0700
From: Nifty niftylinkern Mitch <niftylinkern@niftyegg.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Philipp Reh <sefi@s-e-f-i.de>, linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
Message-ID: <20090611234044.GA21737@compegg.wr.niftyegg.com>
References: <20090604145347.GA27692@miyuki> <20090604155741.GA8999@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604155741.GA8999@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 11:57:41AM -0400, Steven Rostedt wrote:
> On Thu, Jun 04, 2009 at 04:53:47PM +0200, Philipp Reh wrote:
> > Dear list,
> > 
> > I have the following setting in which a client that resides on the same
> > physical network as a server wants to receive any UDP packet that
> > arrives on any of its interfaces sent by that server.
> > 
> > The code sets the broadcast flag, calls bind to INADDR_ANY and
> > uses recvfrom from there on.
> > 
> > Let's say the server resides in the subnet 192.168.6.255 and the
> > client in 192.168.3.255. The server uses its real IP as the packet's
> > sender ip (192.168.6.5).
> 
> You don't say what the client IP is. Let's assume that it is 192.168.3.1
> for simplicity.
> 
> > 
> > Now the first problem I've encountered is the following:
> > If the client removes its default route and doesn't have any route
> > pointing into the subnet the server is in, the packets get discarded
> > (still tcpdump sees them).
> > 
> 
> Are you saying that the server sent to 192.168.3.1 with source ip of
> 192.168.6.5 and the client did not see it?
> 
> > The second problem is that if the server uses the broadcast address as
> > its sender address (255.255.255.255), the packets get always discarded
> > (again, tcpdump sees them).
> 
> Again, what was the destination IP address?
> 
> > Now if the server fakes its sender address to be in the client's subnet,
> > every packet arrives again.
> 
> So the only thing you change is the sender address?
> 
> What tools are you using to read the packets, and how do you know it is
> dropped?
> 
> -- Steve
> 
> > 
> > So my real question is:
> > When does Linux discard packets and how can I prevent it from doing
> > that?


What subnet masks?

If two mutually exclusive TCP/IP subnets are on the same physical network
they will be all but invisible to each other unless there is routing
between them.    With modern switches this is very much.   With modern
smart router/switches interesting things can be done.

The server can have a single MAC configured to send
and receive data on two subnets.

If the server is faking its sender address then other things are happening
(switch, arp, zeroconfig, bogus broadcast address...) so why fake it
set it up to be live on both nets.... make both real.

  eth0:0 192.168.6.5/24 
  eth0:1 192.168.3.5/24

  http://www.faqs.org/docs/Linux-mini/IP-Alias.html

Zeroconfig may also make things work in unexpected ways.
  http://www.zeroconf.org/

# the almost obvious... 
#     10.0.0.0        -   10.255.255.255  (10/8 prefix)
#     172.16.0.0      -   172.31.255.255  (172.16/12 prefix)
#     192.168.0.0     -   192.168.255.255 (192.168/16 prefix)
#     169.254.0.0/16  -   169.254.255.255 (link-local 169.254.0.0/16 prefix)


-- 
	T o m  M i t c h e l l 
	Found me a new hat, now what?

