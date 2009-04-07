Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZDGRuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZDGRuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbZDGRuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:50:39 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:55598 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZDGRui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:50:38 -0400
Date: Tue, 7 Apr 2009 19:52:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] romfs: cleanup romfs_fs.h
Message-ID: <20090407175243.GC13089@uranus.ravnborg.org>
References: <20090407160708.GA11384@lst.de> <20090407174457.GA13089@uranus.ravnborg.org> <20090407174417.GC14462@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407174417.GC14462@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 07:44:17PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 07, 2009 at 07:44:57PM +0200, Sam Ravnborg wrote:
> > On Tue, Apr 07, 2009 at 06:07:08PM +0200, Christoph Hellwig wrote:
> > > There's no kernel-only content in it anymore, so move it to header-y
> > > and remove the superflous #ifdef __KERNEL__.
> > 
> > today there is no difference between header-y and unifdef-y.
> > We pass everything through unifdef these days.
> 
> The __KERNEL__ removal still applies, and as long as we have two
> different variables it should use the correct one.
> 
> But why do you send all through unifdef anyway?  That's a pretty bad
> signal to send when we try to get people to do cleanly seprated headers.

We saw too many cases where headers was not assigned to unifdef-y
after introducing "#ifdef __KERNEL__".
So we integrated the install and unifdef step to avoid this.
And with the header stuff in kbuild redesigned the cost was acceptable to do so.

When I get some spare time I plan to re-implement the unifdef tool
so it does exactly what we want it to do so we can skip the
perl/unifdef stuff we have today.

And I should sent a patch to Linus to get rid of unifdef-y so not to
confuse people.

	Sam
