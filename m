Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYJTKP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYJTKP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYJTKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:15:50 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:47861 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750911AbYJTKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:15:49 -0400
From: swivel@shells.gnugeneration.com
Date: Mon, 20 Oct 2008 05:15:49 -0500
To: Nicolas Cannasse <ncannasse@motion-twin.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
Message-ID: <20081020101549.GH2811@fc6222126.aspadmin.net>
References: <48FC4066.9060303@motion-twin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC4066.9060303@motion-twin.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 10:25:10AM +0200, Nicolas Cannasse wrote:
> Hello,
> 
> We have an application that uses pthreads and (blocking) sockets.
> 
> When the application runs with one single thread in separate processes 
> (using fork()) we don't get any problem.
> 
> However when it's multithreaded, we sometimes get stuck while poll()ing 
> a socket (with events set to POLLIN). Even after the other side of the 
> connection has closed its side of the connection, we are still stuck 
> here. Adding a timeout only makes the poll() exit with 0, so we loop.
> 
> In case we don't loop the next operation is a recv() which will block as 
> well (which is consistent).
> 
> It seems like nothing is longer received on the socket but it's 
> difficult to verify with tcpdump since our server outputs something like 
> 15MB at peek time with 150 hits per seconds.
> 
> We have Shorewall installed and enabled, but what seems strange is that 
> the problem depends on multithreading. It also occurs much more often on 
> the 4 core machines than on a 2 core ones (both with Hyperthreading 
> activated). We're using kernel 2.6.20-15-server (#2 SMP) provided by Ubuntu.
> 
> Any tip on we could fix that or investigate further would be 
> appreciated. After one month of debugging we're really out of solution now.
> 
> Best,
> Nicolas

Your usage pattern is a very common one, I highly doubt you are experiencing
a kernel bug here or many people (including myself) would be complaining.

Shorewall sounds like it might be suspect, are FIN's not coming in when the
remote closes?  You can look in the output of netstat to see what state the
TCP is in, still ESTABLISHED?

Have you tried just disabling the firewall to see if the problem
disappears?

Regards,
Vito Caputo
