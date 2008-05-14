Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbYENSKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbYENSKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYENSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:10:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYENSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:10:21 -0400
Date: Wed, 14 May 2008 10:56:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions,
 failover, performance.
Message-Id: <20080514105654.673aee98.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805140638450.14334@cobra.newdream.net>
References: <20080513174523.GA1677@2ka.mipt.ru>
	<20080513233341.47edea7f.akpm@linux-foundation.org>
	<20080514074028.GA28330@2ka.mipt.ru>
	<20080514080801.GE28330@2ka.mipt.ru>
	<Pine.LNX.4.64.0805140638450.14334@cobra.newdream.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 06:41:53 -0700 (PDT) Sage Weil <sage@newdream.net> wrote:

> > On Wed, May 14, 2008 at 11:40:28AM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > > > If any thread takes more than one kmap() at a time, it is deadlockable.
> > > > Because there is a finite pool of kmaps.  Everyone can end up holding
> > > > one or more kmaps, then waiting for someone else to release one.
> > > 
> > > It never takes the whole LAST_PKMAP maps. So the same can be applied to
> > > any user who kmaps at least one page - while user waits for free slot,
> > > it can be reused by someone else and so on.
> > 
> > Actually CIFS uses the same logic: maps multiple pages in wrteback path
> > and release them after received reply.
> 
> Yes.  Only a pagevec at a time, though... apparently 14 is a small enough 
> number not to bite too many people in practice?
> 

In practice you need a large number of threads performing writeout to
trigger this.  iirc that's how it was demonstrated back in the 2.4
days.  Say, thousands of processes/threads doing write+fsync to
separate files.

