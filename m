Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZJAQon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZJAQon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZJAQon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:44:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51863 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755450AbZJAQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:44:42 -0400
Date: Thu, 1 Oct 2009 17:39:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, dhowells@redhat.com, jeff@garzik.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one
 more flag bit available
Message-ID: <20091001173955.524b2bc6@lxorguk.ukuu.org.uk>
In-Reply-To: <10133.1254402320@redhat.com>
References: <1254384558-1018-11-git-send-email-tj@kernel.org>
	<1254384558-1018-1-git-send-email-tj@kernel.org>
	<10133.1254402320@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Oct 2009 14:05:20 +0100
David Howells <dhowells@redhat.com> wrote:

> Tejun Heo <tj@kernel.org> wrote:
> 
> > +enum {
> > +	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
> > +
> > +	/*
> > +	 * Reserve 3bits off of cwq pointer.  This is enough and
> > +	 * provides acceptable alignment on both 32 and 64bit
> > +	 * machines.
> > +	 */
> > +	WORK_STRUCT_FLAG_BITS	= 3,
> > +
> > +	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
> > +	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
> > +};
> 
> There's some great enum abuse going on here:-)

Its actually a very sensible use of enum - enum constants don't contain
the deathtraps that CPP constants do.

Alan
