Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYFPSHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYFPSHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYFPSG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:06:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62947 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbYFPSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:06:56 -0400
Date: Mon, 16 Jun 2008 11:06:43 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] configfs: module reference counting rules
Message-ID: <20080616180643.GC9657@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20080612235410.GC4012@localdomain> <20080613033309.GE20581@mail.oracle.com> <20080613095159.GH30804@localhost> <20080613202605.GD20576@mail.oracle.com> <20080613222744.GB4153@localdomain> <20080614084701.GA9657@mail.oracle.com> <20080616123912.GR30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616123912.GR30804@localhost>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 02:39:12PM +0200, Louis Rilling wrote:
> On Sat, Jun 14, 2008 at 01:47:01AM -0700, Joel Becker wrote:
> 	IMHO, what really hurts configfs is that the unregister_subsystem() vs
> mkdir() race is not solved unless mkdir() tries to grab a reference on the
> subsystem's module. And the current code of mkdir() does not ensure that in the
> "several modules" case.

	Valid point.  It really does assume that the owner is always the
same.  Have to think about whether that's a big deal.

> I do something like this (and this works):

	I believe it works.  It looks fine.  I'd personally do it more
like what I displayed, wrapping release() rather than creating a
separate operations abstraction and overriding item_operations, but as
you point out that's just implementation.

> > 	Why can't mod_b provide a ->release() that does
> > module_put(self)?
> 
> Because this is simply wrong. Doing module_put(self) exposes the modules's
> function to be run while another cpu unloads the module. Note how I solve this

	How so?  As long as the module_put() is the last thing, you're
fine.  That said, we both have better solutions with our wrappered
functions.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
