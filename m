Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbYBMQps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbYBMQps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYBMQpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:45:35 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56058 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758069AbYBMQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:45:33 -0500
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven =?ISO-8859-1?Q?K=F6hler?= <skoehler@upb.de>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Joerg Dorchain <joerg@dorchain.net>,
       Jon Chelton <jchelton@ffpglobal.com>,
       Stefan Priebe - allied internet ag 
	<s.priebe@allied-internet.ag>
In-Reply-To: <47B31BDE.2030408@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>
	 <1202917468.3109.5.camel@localhost.localdomain>
	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 10:45:22 -0600
Message-Id: <1202921122.3109.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 18:33 +0200, Boaz Harrosh wrote:
> On Wed, Feb 13 2008 at 17:54 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > On Wed, Feb 13 2008 at 17:44 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >> On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
> >>> -	gdth_flush(ha);
> >>> -
> >> This piece doesn't look right.  gdth_flush() forces the internal cache
> >> to disk backing.  If you remove it, you're taking the chance that the
> >> machine will be powered off without a writeback which can cause data
> >> corruption.
> >>
> >> James
> >>
> > Yes. 
> > I have more problems reported, with exit, and am just sending one more patch that puts
> > this back in. Which was tested.
> > 
> > So I will resend this one plus one new one.
> > 
> > Boaz
> > 
> 
> The gdth driver would do a register_reboot_notifier(&gdth_notifier);
> to a gdth_halt() function, which would then redo half of what gdth_exit
> does, and wrongly so, and crash.  
> 
> Are we guaranteed in todays kernel that modules .exit function be called
> on an halt or reboot? If so then there is no need for duplications and
> the gdth_halt() should go.

No.  The __exit section is actually discardable if you promise never to
remove the module.

James


