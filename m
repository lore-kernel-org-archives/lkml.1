Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbXGDKdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbXGDKdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbXGDKdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:33:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45479
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757433AbXGDKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:33:43 -0400
Date: Wed, 04 Jul 2007 03:34:03 -0700 (PDT)
Message-Id: <20070704.033403.35875194.davem@davemloft.net>
To: hch@infradead.org
Cc: kzak@redhat.com, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070704084211.GA19128@infradead.org>
References: <20070703221156.GY14825@petra.dvoda.cz>
	<20070704084211.GA19128@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 4 Jul 2007 09:42:11 +0100

> On Wed, Jul 04, 2007 at 12:11:56AM +0200, Karel Zak wrote:
> >  mount(8) doesn't include filesystem detection code anymore. You
> >  have to compile --with-fsprobe={blkid,volume_id}, and libblkid
> >  (e2fsprogs) or libvolume_id (udev >= v110) is required.
> 
> Sorry, but it's really annoying to pull in a filesystem-specific devel
> package for that.  Having a library is fine, but please move the library
> into util-linux so it's always available without another dependency.  That
> way xfsprogs could for example drop it's own detection library aswell.

I totally agree with Christophe, this dependency is a complete
pain for trying to do util-linux-ng development.  I meant to
complain about this myself.

> >  The package build system is now based on autotools. The build system
> >  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
> >  SUID_LDFLAGS). For more details see the README file
> 
> And this is really dumb.  autotools is a completely pain in the ass and
> not useful at all for linux-only tools.

I second this sentiment as well.  It's not like we expect this stuff
to get used on other systems at all, and the only thing it's getting
used for really is to detect the awful external blkid/volume_id
dependencies.

I totally think this stuff can and should be completely eliminated.
