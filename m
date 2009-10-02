Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZJBHjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZJBHjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZJBHjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:39:02 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58270 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbZJBHjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:39:01 -0400
Date: Fri, 2 Oct 2009 08:39:00 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] checkpatch: fix false EXPORT_SYMBOL warning
Message-ID: <20091002073900.GJ2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-5-git-send-email-dwalker@fifo99.com>
 <20090930174644.GG2957@shadowen.org>
 <1254407291.18167.98.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254407291.18167.98.camel@desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 07:28:11AM -0700, Daniel Walker wrote:
> On Wed, 2009-09-30 at 18:46 +0100, Andy Whitcroft wrote:
> 
> > In theory the thing we are exporting can be an arbitrary number of lines
> > prior to the EXPORT_SYMBOL statement.  We actually want to look at the
> > statement before the EXPORT_*. 
> 
> Why not maintain a variable that holds the name of the function of
> structure that is currently getting parsed .. So that you wouldn't need
> to look back X lines to find anything ? Or did you do that in the
> 0.29-5-* version?

We already have the concept of the current statement which is used
mostly for conditional handling.  I leverage that to say if the 'next'
statement is an EXPORT_SYMBOL_* does this statement have anything to say
about the exported symbol name.  Seems to work better.

-apw
