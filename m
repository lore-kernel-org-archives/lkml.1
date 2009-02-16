Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZBPQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZBPQTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZBPQTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:19:42 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1605 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751180AbZBPQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:19:42 -0500
Date: Mon, 16 Feb 2009 11:19:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Patrick McHardy <kaber@trash.net>
cc: netdev@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SNAT sometimes allows packets to pass through unchanged
In-Reply-To: <4999434F.1050101@trash.net>
Message-ID: <Pine.LNX.4.44L0.0902161112360.15521-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Patrick McHardy wrote:

> Alan Stern wrote:
> > On Thu, 12 Feb 2009, Patrick McHardy wrote:
> > 
> >> If the connection has already timed out (from conntracks perspective),
> >> it has lost its state. Unless connection pickup is enabled, the packet 
> >> will be marked as INVALID because it doesn't belong to a connection.
> >> You can control dropping of these packets yourself by adding the
> >> appropriate "-m state --state INVALID" rules.
> > 
> > I tried adding a rule to log these unaccounted-for packets.  Nothing 
> > showed up, even when I could see the packets being sent.
> 
> Where (table/chain/position) did you add this rule?

In the first position of the POSTROUTING chain in the nat table.  I
don't remember exactly what rules I used, but at one point I tried
something very much like this:

iptables -t nat -I POSTROUTING 1 -s 10.0.0.0/8 -p tcp ! --syn

The counter for this rule remained at 0 even after packets with private 
source addresses were sent through the public interface.

> >> That said, there were
> >> some bugs in the past few releases that caused some bad interaction
> >> between TCP and TCP conntrack (not sure anymore which one of both was
> >> to blame). Its possible that this is the root cause for this, so
> >> you might want to consider a kernel update.
> > 
> > It does sound like the result of a bug.  Do you have any pointers to 
> > patches or locations to check in the source?
> 
> Sorry, there were quite a few patches and I don't remember which
> ones exactly are related.

I tried using 2 6.27 kernel but the problem remained.  Building a later 
version won't be easy because of the need to create the proper config.  
Can you remember in which version these bugs got fixed?

Alan Stern

