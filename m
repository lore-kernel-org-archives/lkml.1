Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYH0SOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYH0SOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYH0SNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:13:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYH0SNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:13:53 -0400
Date: Wed, 27 Aug 2008 10:53:25 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: amruth_pv@yahoo.com, Alan Stern <stern@rowland.harvard.edu>,
       Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB Serial device disconnect causes IRQ disable after using
	ehci controller halted
Message-ID: <20080827175325.GB31820@kroah.com>
References: <434860.93444.qm@web45203.mail.sp1.yahoo.com> <200808262335.05204.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808262335.05204.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 11:35:04PM -0700, David Brownell wrote:
> On Tuesday 26 August 2008, amruth wrote:
> > This patch below does not fix the issue it just stops IRQ being
> > disabled but still ehci hcd crashes. 
> 
> That patch was only intended to address the issue of bogus error
> handling.
> 
> 
> > Please let me know what could be causing the issue.
> 
> If it's like the other case, I'd hope this patch would solve it.
> 
> Note that you also seem to be having hardware or firmware issues
> with the peripheral you're connecting ... this won't change that
> stuff at all.
> 
> - Dave
> 
> ================ SNIP!
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> As noted by Stefan Neis <Stefan.Neis@kobil.com>, we had a recent
> regression with EHCI periodic transfers, in some (seemingly not
> all that common) cases.
> 
> The root cause was that the schedule activation was only loosely
> coupled to the addition or removal of transfers, so two different 
> execution contexts could both think they had to deactivate (or
> conversely activate) the schedule.  So this fix tightens that
> coupling, managing it more like a refcount.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Do you want me to also apply this one?  If so, for .27 or .28?

thanks,

greg k-h
