Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbYENNmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbYENNmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYENNlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:41:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:56046 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYENNly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:41:54 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 09:41:54 EDT
Date: Wed, 14 May 2008 06:41:53 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions,
 failover, performance.
In-Reply-To: <20080514080801.GE28330@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0805140638450.14334@cobra.newdream.net>
References: <20080513174523.GA1677@2ka.mipt.ru> <20080513233341.47edea7f.akpm@linux-foundation.org>
 <20080514074028.GA28330@2ka.mipt.ru> <20080514080801.GE28330@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, May 14, 2008 at 11:40:28AM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > > If any thread takes more than one kmap() at a time, it is deadlockable.
> > > Because there is a finite pool of kmaps.  Everyone can end up holding
> > > one or more kmaps, then waiting for someone else to release one.
> > 
> > It never takes the whole LAST_PKMAP maps. So the same can be applied to
> > any user who kmaps at least one page - while user waits for free slot,
> > it can be reused by someone else and so on.
> 
> Actually CIFS uses the same logic: maps multiple pages in wrteback path
> and release them after received reply.

Yes.  Only a pagevec at a time, though... apparently 14 is a small enough 
number not to bite too many people in practice?

sage
