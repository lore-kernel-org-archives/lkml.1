Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbXELCM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbXELCM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXELCMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:12:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbXELCMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:12:19 -0400
Message-ID: <4645227F.3030905@zytor.com>
Date: Fri, 11 May 2007 19:12:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mark Glines <mark@glines.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
References: <20070511170135.7c38615f@chirp>
In-Reply-To: <20070511170135.7c38615f@chirp>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Glines wrote:
> 
> By a one-in-a-million coincidence, this machine has a default port
> range starting with 2048, and this breaks things for me.  I'm trying to
> run both klive and nfs on this box, but klive starts first (probably
> because of the filename sort order), and claims UDP port 2049 for its
> own purposes, causing the nfs server to fail to start.
> 
> If the bind hash size is over a certain threshold, the range
> 32768-61000 is used.  If it is under a certain threshold, a range
> like (1024|2048|3072)-4999 is used, depending on exactly how small it
> is.  Thix box happened to get the 2048-4999 range, which broke nfs.
> 
> A comment just above the code that does this says, "Try to be a bit
> smarter and adjust defaults depending on available memory."  "smarter"?
> Maybe, maybe not.  Either way, it's unexpected.
> 
> Following the principle of least astonishment, I think it seems better
> to use high, out-of-the-way port numbers regardless of how much RAM the
> system has.  So, the following patch changes this behavior slightly.
> The system still picks a dynamic range depending on the bind hash size,
> but now, all ranges start with 32768.  I suppose another reasonable way
> to do this would be to end all ranges with 61000, or something like
> that.
> 

Yes, that would be better.  The IANA recommended port range for dynamic
ports are 49152-65535; Linux extends this to 32768 and chops off some of
the really high ports, but keeping them in the high range is thus the
right thing to do.

	-hpa
