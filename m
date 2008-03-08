Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYCHMG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYCHMG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 07:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYCHMGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 07:06:19 -0500
Received: from phunq.net ([64.81.85.152]:36285 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753017AbYCHMGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 07:06:18 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] An alternative interface to device mapper
Date: Sat, 8 Mar 2008 04:06:15 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <200803050129.43172.phillips@phunq.net> <20080308113803.GB4016@ucw.cz>
In-Reply-To: <20080308113803.GB4016@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803080406.16305.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Saturday 08 March 2008 03:38, Pavel Machek wrote:
> > Unlike a pipe, there is no waiting for input on a ddlink: if there is 
> > nothing to read then the read returns immediately with zero length.  If 
> > some other behavior is desired it can be obtained using poll.
> 
> That's kind of strange, no?

It doesn't feel strange in practice.  The ddlink framework itself does
not implement this, the module does (e.g. ddsetup).  So you can put a
poll wait in your read method if that suits your interface.  It just
does not seem to be useful for ddsetup, which does not produce any
data of the kind that needs an application to sit in a loop waiting for
something to arrive.  If there is an application like that, it would
probably want to poll the ddlink anyway, to avoid having a whole thread
dedicated to just that.

Maybe the reason it does not feel strange to omit the wait is, reading
from proc never waits.  A ddlink fd is more like proc than like a pipe.
It was Trond who started called his thing a "pipefs", blame him ;-)
 
> Should not description of interface go to Doc* somewhere?

Yes, will fix.

Daniel
