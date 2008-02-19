Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYBSPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYBSPmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYBSPlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:41:53 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:11306 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYBSPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:41:52 -0500
Date: Tue, 19 Feb 2008 16:41:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 07/13] Initialize per cpu lowcores on cpu hotplug.
Message-ID: <20080219154149.GB11599@osiris.boeblingen.de.ibm.com>
References: <20080219144047.587547541@de.ibm.com> <20080219144504.392301782@de.ibm.com> <20080219151355.GA24547@wavehammer.waldi.eu.org> <20080219153855.GA11599@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219153855.GA11599@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 04:38:56PM +0100, Heiko Carstens wrote:
> On Tue, Feb 19, 2008 at 04:13:55PM +0100, Bastian Blank wrote:
> > On Tue, Feb 19, 2008 at 03:40:54PM +0100, Martin Schwidefsky wrote:
> > > +	/*
> > > +	 * Only need to copy the first 512 bytes from address 0. But since
> > > +	 * the compiler emits a warning if src == NULL for memcpy use copy_page
> > > +	 * instead. Copies more than needed but this code is not performance
> > > +	 * critical.
> > > +	 */
> > > +	copy_page(lowcore, &S390_lowcore);
> > 
> > Boah, workaround alert. Why do you not fix the compiler?
> 
> We need to copy from address 0 (that's where the lowcore resides). But gcc
> insists to complain if memcpy is used with src == NULL.. Now what?

Erm sorry, misread your question. Usually it's a bug to use memcpy with
src == NULL. In this case it's ok. So I think it's perfectly ok if gcc
emits a warning.
If you know of a better way to get around this please let me know.
