Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXJUR3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXJUR3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXJUR3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:29:24 -0400
Received: from 1wt.eu ([62.212.114.60]:3475 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbXJUR3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:29:24 -0400
Date: Sun, 21 Oct 2007 19:29:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tal Kelrich <tal@musicgenome.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4/2.6 local TCP connect oddity
Message-ID: <20071021172901.GV10199@1wt.eu>
References: <20071021175337.605e843e@shodan.orpak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021175337.605e843e@shodan.orpak.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Oct 21, 2007 at 05:53:37PM +0200, Tal Kelrich wrote:
> Hi,
> 
> I've run into a problem where a process trying to connect to a local
> port within the local port range eventually ends up connected to itself,
> with source port = dest port.
> 
> similar behavior can be gotten by running netcat as follows:
> nc -p 1025 localhost 1025
> 
> I'm not really sure if that's a bug, but the original case was at least
> unexpected.

It is not a bug, it is caused by the "simultaneous connect" feature of
TCP. Although rarely used, in TCP you can connect two clients together.
They just have to exchange their SYN, SYN/ACK then ACK and bingo, they're
connected. In fact, you found the easiest way to achieve it, by using the
same port. To demonstrate the feature, I'm used to either temporarily
block SYNs with iptables, or by unplugging the cable between two machines.

I personally dislike this feature as it can be exploited to prevent any
client from connecting to the outside by flooding it with SYN packets to
its guessed source port. Anyway, most stateful firewalls don't let this
pass through.

> Regards,
> 	Tal Kelrich

Regards,
Willy

