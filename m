Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0CEWkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:40:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836Ab0CEWkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:40:41 -0500
Date: Fri, 5 Mar 2010 14:40:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.tw.chua@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, petr@vmware.com,
       Eli Collins <ecollins@vmware.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for
 vmware 7.0.1
In-Reply-To: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com>
Message-ID: <alpine.LFD.2.00.1003051438280.3906@localhost.localdomain>
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Jeff Chua wrote:
> 
> Linux version v2.6.33-5399-gcc7889f with reiser3 and vmware-7.0.1
> 
> Starting vmware just hang even before displaying the main GUI. Reverting
> 554f76962d3a6eb5110415f1591aca83f96a84ae solves the problem.
> 
> It seems vmware is trying to access the USB but this commit blocks it.
> 
> So, is this a vmware problem or shall this be reverted?

It's almost certainly a deadlock through some path that wasn't tested.

Can you enable lockdep on that kernel when you run vmware, which should 
give us a nice callchain etc, and hopefully make it very obvious what goes 
on.

Reverting it is obviously an option, but with some more info maybe there's 
a better solution.

(It may be that the deadlock is obvious to Oliver/Greg even without any 
lockdep chains, of course, but still worth trying, I suspect)

		Linus
