Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZKJVR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZKJVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZKJVR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:17:28 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:55239 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbZKJVR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:17:27 -0500
Subject: Re: sunrpc port allocation and IANA reserved list
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF9D5D1.9040501@nortel.com>
References: <4AF9A63B.6010101@nortel.com>
	 <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
	 <4AF9B2CF.6050305@nortel.com>
	 <1257884799.3044.7.camel@heimdal.trondhjem.org>
	 <4AF9D5D1.9040501@nortel.com>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 06:17:24 +0900
Message-Id: <1257887844.3044.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 1834 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8CFA5F62AA9D374A27747ACCE9E5B4E8AFDF00D1
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 36 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 15:06 -0600, Chris Friesen wrote:
> On 11/10/2009 02:26 PM, Trond Myklebust wrote:
> > On Tue, 2009-11-10 at 12:37 -0600, Chris Friesen wrote:
> >> On 11/10/2009 11:53 AM, Ben Hutchings wrote:
> >>> On Tue, 2009-11-10 at 11:43 -0600, Chris Friesen wrote:
> >>
> >>>> Given that a userspace application can be stopped and restarted at any
> >>>> time, and a sunrpc registration can happen at any time, what is the
> >>>> expected mechanism to prevent the kernel from allocating a port for use
> >>>> by sunrpc that reserved or well-known?
> >>>>
> >>>> Apparently Redhat and Debian have distro-specific ways of dealing with
> >>>> this, but is there a standard solution?  Should there be?
> >>>>
> >>>> The current setup seems suboptimal.
> >>>
> >>> I believe both RH and Debian are using the same implementation:
> >>> <http://cyberelk.net/tim/software/portreserve/>.
> >>
> >> That helps with the startup case, but still leaves a possible hole if an
> >> app using a fixed port number is restarted at runtime.  During the
> >> window where nobody is bound to the port, the kernel could randomly
> >> assign it to someone else.
> > 
> > Just use /proc/sys/sunrpc/{max,min}_resvport interface to restrict the
> > range used to a safer one. That's what it is for...
> 
> What constitutes a "safer range"?  IANA has ports assigned
> intermittently all the way through the default RPC range.  The largest
> unassigned range is 922-988 (since 921 is used by lwresd).  If someone
> needs more than 66 ports, how are they supposed to handle it?

Distributions can, and should, set the default to whatever range that
constitutes a broad percentile of their customers, and then leave
instructions on how to change that default for the people who run the
funky setups.

The people who are trying to run absolutely all IANA registered services
on a single Linux machine that is also trying to run as an NFS client
may have a problem, but then again, how many setups do you know who are
trying to do that?

  Trond

