Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZHYVYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZHYVYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZHYVYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:24:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbZHYVYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:24:54 -0400
Date: Tue, 25 Aug 2009 14:19:44 -0700
From: Greg KH <gregkh@suse.de>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unable to handle kernel NULL pointer / tty / 2.6.31-rc7
Message-ID: <20090825211944.GA21257@suse.de>
References: <200908252237.54324.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908252237.54324.denys@visp.net.lb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 10:37:54PM +0300, Denys Fedoryschenko wrote:
> Kernel 2.6.31-rc7
> x86 , 32-bit
> gcc 4.4.1
> 
> 
> Happened on heavy network load, i don't know if it is related.
> 
> Here is part of remote syslog, notice failed dropbear ssh authentication.
> I guess if it is not fixed - it is critical to upcoming release, seems bug 
> triggered by ssh worm.
> 
> Aug 25 22:34:35 10.22.24.2 login[2099]: pam_radius_auth: DEBUG: 
> getservbyname(radius, udp) returned -1209037784.
> Aug 25 22:34:36 10.22.24.2 login[2099]: pam_unix(login:auth): authentication 
> failure; logname= uid=0 euid=0 tty=pts/0 ruser= rhost=  user=root
> Aug 25 22:34:37 10.22.24.2 ripd[1862]: rip_read: cannot find interface for 
> packet from 80.83.24.49 port 520
> Aug 25 22:34:41 10.22.24.2 ripd[1862]: Neighbor 10.22.22.2 doesnt have 
> connected interface!
> Aug 25 22:34:46 10.22.24.2 kernel: [22630.973706] BUG: unable to handle kernel 
> NULL pointer dereference at (null)
> Aug 25 22:34:46 10.22.24.2 kernel: [22630.973807] IP: [<c0251814>] 
> n_tty_read+0x3c6/0x5ad
> 
> Full BUG message
> 
> 
>  [22630.973706] BUG: unable to handle kernel NULL pointer dereference at 
> (null)

Can you try this on Linus's latest tree, he has just fixed a bug in this
area.

thanks,

greg k-h
