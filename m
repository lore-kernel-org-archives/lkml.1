Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbXJLNTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbXJLNTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXJLNSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:18:53 -0400
Received: from [212.12.190.111] ([212.12.190.111]:52728 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbXJLNSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:18:52 -0400
From: Al Boldi <a1426z@gawab.com>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
Date: Fri, 12 Oct 2007 16:18:51 +0300
User-Agent: KMail/1.5
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710120031.42805.a1426z@gawab.com> <200710121525.44510.a1426z@gawab.com> <470F6927.9040505@trash.net>
In-Reply-To: <470F6927.9040505@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121618.51046.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Al Boldi wrote:
> >>>The problem is that people think they are safe with the filter table,
> >>>when in fact they need the prerouting chain to seal things.  Right now
> >>>this is only possible in the mangle table.
> >>
> >>Why do they need PREROUTING?
> >
> > Well, for example to stop any transient packets being forwarded.  You
> > could probably hack around this using mark's, but you can't stop the
> > implied route lookup, unless you stop it in prerouting.
>
> This also works fine in FORWARD with a little extra overhead.
> If you really have to save resources, you should use PREROUTING/raw
> to also avoid the creation of a connection tracking entry.

Yes sure, if you use nat.  But can you see how forcing people into splitting 
their rules across tables adds complexity.  And without ipt_REJECT patch, 
they can't even use REJECT in prerouting, which forces them to do some 
strange hacks.

IMHO, we should make things as easily configurable as possible, and as things 
stand right now, the filter-table is completely useless for 99% of 
use-cases.


Thanks!

--
Al

