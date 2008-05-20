Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYETI0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYETI0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYETI0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:26:19 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:50961 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbYETIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:25:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:content-transfer-encoding:in-reply-to:user-
	agent;
	b=vjTZgj2bQhzSRZhC+AZU1Z8yrdTJskUgm5jqyoyBgJFu1J0CDqZV9JnmF1fpk
	KjG3tKkHisOd9V+hMF2CQEpsw==
Date: Tue, 20 May 2008 10:25:21 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Brownell <david-b@pacbell.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, nico@cam.org
Subject: Re: [Bug #10713] ehci splatter in 2.6.26-rc2
Message-ID: <20080520082521.GA19889@xi.wantstofly.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <20080519231126.GA15099@xi.wantstofly.org> <20080520001824.GA15878@xi.wantstofly.org> <200805192313.11600.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805192313.11600.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 11:13:11PM -0700, David Brownell wrote:

> > A bisect turns up this:
> > 
> >         7329e211b987a493cbcfca0e98c60eb108ab42df is first bad commit
> >         commit 7329e211b987a493cbcfca0e98c60eb108ab42df
> >         Author: Alan Stern <stern@rowland.harvard.edu>
> >         Date:   Thu Apr 3 18:02:56 2008 -0400
> > 
> >             USB: root hubs don't lie about their number of TTs
> >             
> >             Currently EHCI root hubs enumerate with a bDeviceProtocol code
> >             indicating that they possess a Transaction Translator.  However the
> >             vast majority of controllers do not...
> > 
> > And indeed, reverting this commit from 2.6.26-rc3 makes my system
> > stop oopsing when I plug in the USB-PS/2 adapter (a low speed device),
> > and makes it work again as it did in 2.6.25.
> > 
> > Any other info I can provide or tests I can run?
> 
> I'm guessing that this has a version of the ARC/TDI/whoever-now-owns-it
> IP, on a PCI bus?  But without the integrated TT option?
> 
> If this is on a PCI bus, then try removing the ehci-pci.c line added
> by that patch, see if that helps.

No, this is not on a PCI bus -- this is the on-chip EHCI controller
of the Marvell Orion ARM SoC (ehci-orion.c.)

I have honestly no idea whether the IP is in-house or third-party.
