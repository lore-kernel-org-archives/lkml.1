Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZHKQue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZHKQue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZHKQud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:50:33 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58353 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbZHKQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:50:32 -0400
Subject: Re: [PATCH 12/14] scsi: use printk_once
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <adahbwe70xz.fsf@cisco.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	 <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
	 <1250008813.4301.55.camel@mulgrave.site>  <adahbwe70xz.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 11:50:28 -0500
Message-Id: <1250009428.4301.59.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 09:46 -0700, Roland Dreier wrote:
> > > -	static int vers_printed;
>  > > -
>  > > -	if (!vers_printed) {
>  > > -		printk(KERN_INFO "%s", version);
>  > > -		vers_printed = 1;
>  > > -	}
>  > > +	printk_once(KERN_INFO "%s", version);
> 
>  > There's really no point to this beyond code churn.  Both patterns are
>  > correct uses so conversion buys us nothing.
> 
> It's a pretty small gain but I do think 6 lines -> 1 line does have value.

Not at the expense of churning the code base of marginal drivers.

I'm not entirely convinced this is a good pattern to begin with.  If you
add too many patterns you're effectively developing an overly complex
development language and rule set.  Even if I go with this on the basis
of readability (as you say, one line for six), then I still don't think
we should churn the code base to convert correct open coding to it; we
should just use it ongoing.

James


