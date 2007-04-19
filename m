Return-Path: <linux-kernel-owner+w=401wt.eu-S637782AbXDSOs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637782AbXDSOs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637783AbXDSOs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:48:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S637782AbXDSOs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:48:57 -0400
Date: Fri, 20 Apr 2007 00:48:44 +1000
From: David Chinner <dgc@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070419144844.GH32602149@melbourne.sgi.com>
References: <20070419065404.GB1782@ff.dom.local> <20070419073222.GA438@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419073222.GA438@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:32:22AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > +		int i = 1000;
> >  
> > -		while (!cancel_delayed_work(dwork))
> > +		while (!cancel_delayed_work(dwork)) {
> >  			flush_workqueue(wq);
> > +			BUG_ON(!i--);
> > +		}
> 
> if then make it a WARN_ON(). But ... dont we have the softlockup 
> detector for such cases? Does CONFIG_DETECT_SOFTLOCKUP=y give you enough 
> information?

No, you won't get a soft lockup - flush_workqueue() has a 
schedule() call in the middle of it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
