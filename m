Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbYDBXHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbYDBXHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbYDBXH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:07:27 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:37091 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757661AbYDBXHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:07:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5qfAIKLoG97t1jtN0G2bxg6yUP2Bj1o7kHvtI83Wh8k6QHH+naUHRu4zmaYy51UfkmlvTdfNR7XaBajtA1kCs/3aKN0Ry79Apdm+YfayNQJ2eNwJDuP6RpFuVlr9XT7Y0T01WkmDMZJ1qJRFAcTcAIODYZRP3p2qBoCeyepsrno=  ;
X-YMail-OSG: OdBd3WsVM1ltM17.RzRPdfuIX5URoL0npSoBCog4W6n42YcsSn6rT00zVKdjsUUkblYGL_owVQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
Date: Wed, 2 Apr 2008 16:07:21 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021639290.2107-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021639290.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021607.22424.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Alan Stern wrote:
> On Wed, 2 Apr 2008, David Brownell wrote:
> 
> > Those hcd->state tests have been getting more and more
> > dodgey as time goes by.  At this point I hardly trust
> > any of them.  There *IS* no clear state machine which
> > governs the usbcore/HCD interaction.
> 
> ISTR trying to make that same point a few times over the past two or 
> three years...  :-)

Was there any argument about that fact?  The question was
more "shouldn't there actually *be* such a state machine"
than "do we have one yet".


> It would make more sense for each HCD to keep its own private "state" 
> variable.  The interaction with usbcore can be broken down into a few 
> simple tests, such as:
> 
> 	Is the HC dead?
> 	Is the HC (i.e., the PCI or platform device) suspended?
> 	Is the HC running?
> 	Is it okay to submit an URB?
> 
> There's plenty of redundancy in this list, and some of the information
> may already be available in hcd->self.root_hub->state.  In many or most
> cases, these questions can't be answered in a race-free manner anyhow, 
> which limits their usefulness.

At any given instant, all of them have valid answers.
The only one that's not resolvable by mutual exclusion
on the HCD's spinlock is "is it dead", since the HC
could crap out at any time.  (Nowadays that's fortunately
rare ... we've been whomping on such bugs for long enough
by now!)

- Dave

 
