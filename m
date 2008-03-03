Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYCCS6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYCCS6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761337AbYCCS54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:57:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761300AbYCCS5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:57:55 -0500
Date: Mon, 3 Mar 2008 13:57:42 -0500
From: Rik van Riel <riel@redhat.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 02/21] Use an indexed array for LRU variables
Message-ID: <20080303135742.233f6746@cuia.boston.redhat.com>
In-Reply-To: <20080229160320.GG28849@shadowen.org>
References: <20080228192908.126720629@redhat.com>
	<20080228192928.079732330@redhat.com>
	<20080229160320.GG28849@shadowen.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 16:03:20 +0000
Andy Whitcroft <apw@shadowen.org> wrote:

> >  	/* First 128 byte cacheline (assuming 64 bit words) */
> >  	NR_FREE_PAGES,
> > -	NR_INACTIVE,
> > -	NR_ACTIVE,
> > +	NR_INACTIVE,	/* must match order of LRU_[IN]ACTIVE */
> > +	NR_ACTIVE,	/*  "     "     "   "       "         */
> 
> This little ordering constraint is a little nasty.  If we have enum_list
> available at this point then we can make sure that these order correctly
> automatically with something like this:

A little, true.

However, we need to line up with vmstat_text as well, so I suspect
the best way to make this friendlier to people new to this part of
the kernel would be to add more documentation, not more magic.

-- 
All Rights Reversed
