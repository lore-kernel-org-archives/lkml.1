Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXLKTr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXLKTr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXLKTrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:47:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42720 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbXLKTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:47:51 -0500
Date: Tue, 11 Dec 2007 20:47:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, nashif@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20071211194751.GB21864@one.firstfloor.org>
References: <p7363z5nlo8.fsf@bingen.suse.de> <475ED912.609@linux.intel.com> <20071211185317.GA21864@one.firstfloor.org> <20071211.110202.186865875.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211.110202.186865875.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 11:02:02AM -0800, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Tue, 11 Dec 2007 19:53:17 +0100
> 
> > Ok but saving oops is such a useful facility that we'll probably
> > need to think about implementing SOAP in the kernel.
> 
> Ummm, no.
> 
> UDP is stateless, a stripped down copy of TCP we simply

UDP? Anyways it turns out TCP is not even needed.

> do not need.  We also do not need XML in the kernel either.

Even if it means you can get users to submit clear logged oopses out 
of many machines who hung silently before? 

Sure most of the XML infrastructure that tends to be used in 
user space is pure bloat. But if you don't want universal
interoperability and just for specific applications
you'll essentially just have a few hardcoded strings that
you'll write down some firmware interface and then a simple
parser to read the results. Again that wouldn't be a generic
XML parser, but just something tailored to the specific job.

I doubt it would be much worse code-wise than some of the more 
bizarre /proc ASCII interfaces.


> If they want to support things like this they should do it in the
> firmware of the management entity like every other sane server
> platform does these days.

They do -- the problem is that you need SOAP to talk the firmware.
After reboot the user space can get it out of the firmware again.

> The console and OOPS messages should go over an extremely resilient
> transport which is as simple as possible which usually means shared
> memory or I/O memory with some simple handshake or doorbell.  This

With soap it would be a slightly more complicated handshake 
and a few hard coded text strings around the actual information.
While that's not pretty if the result is worth it (and I think
general oops logging would be worth a lot of things) that's not too
bad.

-Andi
