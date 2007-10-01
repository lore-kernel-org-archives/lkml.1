Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbXJAWlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbXJAWlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXJAWlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:41:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43524 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXJAWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:41:36 -0400
Date: Mon, 1 Oct 2007 17:41:32 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Message-ID: <20071001224132.GH4338@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com> <20070927221031.GY3899@parisc-linux.org> <20070927233437.GF18686@austin.ibm.com> <20071001201247.GN12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001201247.GN12049@parisc-linux.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 02:12:47PM -0600, Matthew Wilcox wrote:
> 
> I think the fundamental problem is that completions aren't really
> supposed to be used like this.  Here's one attempt at using completions
> perhaps a little more the way they're supposed to be used, 

Yes, that looks very good to me.  I see it solves a bug that
I hadn't been quite aware of. I don't understand why 
struct host_data is preferable to struct sym_shcb (is it because 
this is the structure that is "naturally protectected" by the 
spinlock?)

My gut instinct is to say "ack", although prudence dictates that 
I should test first. Which might take a few days...

> although now
> I've written it, I wonder if we shouldn't just use a waitqueue instead.

I thought that earlier versions of the driver used waitqueues (I vaguely
remember "eh_wait" in the code), which were later converted to 
completions (I also vaguely recall thinking that the new code was
more elegant/simpler). I converted my patch to use the completions 
likewise, and, as you've clearly shown, did a rather sloppy job in 
the conversion.

I'm tempted to go with this patch; but if you prod, I could attempt
a wait-queue based patch.

--linas

