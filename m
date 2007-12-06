Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbXLFSes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbXLFSes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXLFSek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:34:40 -0500
Received: from waste.org ([66.93.16.53]:51705 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbXLFSej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:34:39 -0500
Date: Thu, 6 Dec 2007 12:34:23 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       jason.wessel@windriver.com
Subject: Re: a problem with NETPOLL/KGDBoE
Message-ID: <20071206183423.GZ19691@waste.org>
References: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 08:22:15PM +0200, Ramagudi Naziir wrote:
> Hi all,
> 
> It's probably only me, but I can't connect to a kgdb host because
> of bouncing ICMP unreachables. I'll be glad if you could take a look
> to see if it's a bug or not.
> 
> Details:
> - running a cloned  version of kgdb_2.6.23 branch of Jason's
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
> 
> - "modprobe kgdboe kgdboe='@10.0.0.28/,@10.0.0.11/'" works fine,
> and var/log/messages get filled with six kgdboe network configuration
> messages (local port 6443, local ip 10.0.0.28, interface eth0,
> remote port 6442, remote ip 10.0.0.11, remote mac ff:ff:ff:ff:ff:ff).

...

> 19:30:53.424248 IP 10.0.0.11.32785 > 10.0.0.28.6433: UDP, length 5
> 19:30:53.424323 IP 10.0.0.11.32785 > 10.0.0.28.6433: UDP, length 14

Hmmm, 6443 != 6433 (typo?) and 32785 != 6442 (config problem). Yes,
netpoll will ignore incoming UDP -from- the wrong port/ip/mac, since
it's otherwise bypassing the firewall layer. And of course, it won't
accept packets -to- the wrong address either. I forget how to deal
with the source address issue in connection with GDB, perhaps Jason
will remind us.

-- 
Mathematics is the supreme nostalgia of our time.
