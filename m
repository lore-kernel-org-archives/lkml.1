Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbXG0E0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbXG0E0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXG0E0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:26:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42256 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXG0E0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:26:30 -0400
Date: Fri, 27 Jul 2007 06:27:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] ia64: fix a few section mismatch warnings
Message-ID: <20070727042744.GA10144@uranus.ravnborg.org>
References: <20070726210141.GA7266@uranus.ravnborg.org> <20070727011813.GQ27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727011813.GQ27237@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 02:18:13AM +0100, Al Viro wrote:
> On Thu, Jul 26, 2007 at 11:01:41PM +0200, Sam Ravnborg wrote:
>   
> > +static void *__init_refok alloc_rte(unsigned long size)
> > +{
> > +	return alloc_bootmem(size);
> > +}
> 
> That makes no sense at all.  If we ever call that after freeing initmem,
> we are screwed, period.  Sounds like __init fodder.

The call site has logic to prevent this from being called after init.
And the call site cannot be made __init and to limit the scope of
the __init_refok a small function is used.

So unless I mis-understood something the above should be OK.

	Sam
