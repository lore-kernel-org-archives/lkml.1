Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbXIZD4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbXIZD4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXIZD4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:56:35 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:36647 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbXIZD4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:56:34 -0400
Date: Wed, 26 Sep 2007 12:55:43 +0900
To: James.Bottomley@SteelEye.com
Cc: jeff@garzik.org, matthew@wil.cx, tomof@acm.org, akpm@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: queued patches for SCSI for 2.6.24
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <1190778353.8707.29.camel@localhost.localdomain>
References: <20070926025608.GA3899@parisc-linux.org>
	<46F9D328.4030801@garzik.org>
	<1190778353.8707.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070925092106U.tomof@acm.org>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 22:45:53 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2007-09-25 at 23:34 -0400, Jeff Garzik wrote:
> > Matthew Wilcox wrote:
> > > On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
> > >> Are there any const-ness worries for scsi_host_template, or plans for 
> > >> the future?  I do not see any other examples of the host template 
> > >> members getting modified.
> > > 
> > > Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
> > > I've come across trawling the horrible unmaintained drivers.  I'd love
> > > to see scsi_host_template become const, but it's not happening any time
> > > soon, and we can address this little piece when the time comes.
> > 
> > Well, sure, the driver is the owner of that memory.
> > 
> > We're talking about common code.
> > 
> > If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.
> 
> Well, I don't like mucking with the template either.
> 
> This whole mess is generated basically because the zero default of the
> template should be treated as initiator.  How about this, which makes
> that manifest?

But how can we handle dual-mode drivers?

luce:/sys/class/scsi_host/host0$ cat supported_mode
Initiator, Target


The values are not enumerated. They are like FC_PORT_ROLE.
