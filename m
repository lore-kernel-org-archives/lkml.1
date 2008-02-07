Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYBGGmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYBGGmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYBGGmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:42:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51476
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbYBGGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:42:15 -0500
Date: Wed, 06 Feb 2008 22:42:45 -0800 (PST)
Message-Id: <20080206.224245.228156843.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080207064407.GA22963@suse.de>
References: <20080207054738.GB20902@suse.de>
	<20080206.220544.238067538.davem@davemloft.net>
	<20080207064407.GA22963@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Wed, 6 Feb 2008 22:44:07 -0800

> On Wed, Feb 06, 2008 at 10:05:44PM -0800, David Miller wrote:
> > From: Greg KH <gregkh@suse.de>
> > Date: Wed, 6 Feb 2008 21:47:38 -0800
> > 
> > > On Wed, Feb 06, 2008 at 08:06:18PM -0800, David Miller wrote:
> > > > I redid the bisect to make sure it absolutely was that specific
> > > > changeset, and it is.
> > > 
> > > Thanks for doing that, I'll let you know when I have a patch to test.
> > 
> > I found the problem, it's the "whole_disk" partition attribute.
> > 
> > Look in fs/partitions/check.c:add_partition() where it tests the
> > ADDPART_FLAG_WHOLEDISK flag.
> 
> So, if you just comment out that whole "if (flags &
> ADDPART_FLAG_WHOLEDISK)" chunk, does the oops go away?  I think that is
> the real solution here as I don't see what this attribute is supposed to
> be showing.

See my other reply, it's supposed to just exist and be
a zero length file.  udev looks for it to determine
which partition is the "whole disk" partition
