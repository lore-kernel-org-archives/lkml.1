Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbYBONof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbYBONof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYBONo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:44:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50349 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYBONo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:44:27 -0500
Date: Fri, 15 Feb 2008 15:20:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080215142010.GA29552@one.firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B58EAA.8040405@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> Alasdair G Kergon wrote:
> > On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> >> Implement barrier support for single device DM devices
> >  
> > Thanks.  We've got some (more-invasive) dm patches in the works that
> > attempt to use flushing to emulate barriers where we can't just
> > pass them down like that.
> 
> I wonder if it's worth the effort to try to implement this.

DM in theory has some more knowledge for optimization. e.g. for example if 
it knows that a stream of requests hits only a single device then
it can just pass the barriers through again and only flush when there
is really a request dependency between different devices.  File systems can't
do it that fine grained; it's either all or nothing.

I don't know if doing it fine grained will much difference in performance
though. The only way to find out would be to try it.

-Andi
