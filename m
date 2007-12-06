Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbXLFWiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbXLFWiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbXLFWi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:38:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44055 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbXLFWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:38:26 -0500
Date: Thu, 6 Dec 2007 23:38:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206223823.GH20595@one.firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com> <20071206220754.GF20595@one.firstfloor.org> <20071206221837.GE30293@cs.unibo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206221837.GE30293@cs.unibo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 11:18:37PM +0100, Renzo Davoli wrote:
> * IPN is for inter-process communication. It is *not* directly related 
> to TCP-IP or Ethernet.
> 
> If you want you can call it Inter Process Bus Communication.  It is an
> extension of AF_UNIX.  Comments saying that some services can be
> implemented by using TCP-IP multicast protocols are unrelated to IPN.
> All AF_UNIX services could be implemented as TCP-IP services on
> 127.0.0.1. Do we abolish AF_UNIX, then?  The problem is that to use
> TCP-IP, you'd need to wrap the packets with TCP or UDP, IP and Ethernet

No ethernet headers on localhost. Just to give you a perspective:
IP+TCP headers are 50 bytes (with timestamps) and IP+UDP is 28 bytes.
On the other hand the sk_buff+skb_shared_info header which are used for 
all socket communication in Linux and have to be mostly set up always
are 192+312bytes on 64bit [parts of the 312 bytes is an array that is 
typically only partly used] or 156+236 bytes on 32bit. So the network
headers dwarf the internal data structures.

There might be other reasons why TCP/IP is slower, but arguing 
with the size of the headers is just bogus.

My personal feeling would be that if TCP/IP is too slow for something
it is better to just improve the stack than to add a completely
new socket family. That will benefit much more applications without
requiring to change them.

About the only good reason to use UNIX sockets is when you need to use
file system permissions. 

> * IPN services (like AF_UNIX) do not require root privileges.
> 
> There are many communication services where the user need broadcast or
> p2p among user processes.  If a user (not root) wants to run several

IP Multicast when properly set up also doesn't need root.

Broadcast is kind of obsolete anyways.

> User-Mode Linux, Qemu, Kvm VM the only way to have them connected
> together is our Virtual Distributed Ethernet.  (For this reason VDE

They could easily just tunnel over a local multicast group for example.

-Andi

