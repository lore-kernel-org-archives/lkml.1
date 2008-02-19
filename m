Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbYBSPjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbYBSPjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYBSPi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:38:59 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:44766 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYBSPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:38:58 -0500
Date: Tue, 19 Feb 2008 16:38:56 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 07/13] Initialize per cpu lowcores on cpu hotplug.
Message-ID: <20080219153855.GA11599@osiris.boeblingen.de.ibm.com>
References: <20080219144047.587547541@de.ibm.com> <20080219144504.392301782@de.ibm.com> <20080219151355.GA24547@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219151355.GA24547@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 04:13:55PM +0100, Bastian Blank wrote:
> On Tue, Feb 19, 2008 at 03:40:54PM +0100, Martin Schwidefsky wrote:
> > +	/*
> > +	 * Only need to copy the first 512 bytes from address 0. But since
> > +	 * the compiler emits a warning if src == NULL for memcpy use copy_page
> > +	 * instead. Copies more than needed but this code is not performance
> > +	 * critical.
> > +	 */
> > +	copy_page(lowcore, &S390_lowcore);
> 
> Boah, workaround alert. Why do you not fix the compiler?

We need to copy from address 0 (that's where the lowcore resides). But gcc
insists to complain if memcpy is used with src == NULL.. Now what?
