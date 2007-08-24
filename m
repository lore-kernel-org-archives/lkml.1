Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbXHXLQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbXHXLQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 07:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXHXLQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 07:16:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60207 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbXHXLQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 07:16:23 -0400
Date: Fri, 24 Aug 2007 16:59:15 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Paul Mundt <lethal@linux-sh.org>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the value of the macro "__setup_param"?
In-Reply-To: <20070824100217.GA32109@linux-sh.org>
Message-ID: <alpine.LFD.0.999.0708241650540.20322@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708240516080.14019@localhost.localdomain>
 <20070824095058.GA32013@linux-sh.org> <Pine.LNX.4.64.0708240548220.15507@localhost.localdomain>
 <20070824100217.GA32109@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Aug 2007, Paul Mundt wrote:
> 
> > > > include/linux/init.h:#define __setup_param(str, unique_id, fn, early)      \
> > > > include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
> 
> Notice the problem now? :-)

We should probably keep it that way. I don't see why anybody should be
using __setup_param directly anyway, so this becomes a nice build-time
error to flag such errant usage :-)

Seriously speaking, though, we should probably just get rid of that
wrong line. It's just an init.h-internal macro to be used by early_param
and __setup, and because those are themselves empty when MODULE, there's
no issues in removing the (unused, broken) __setup_param either.
