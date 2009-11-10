Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZKJU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZKJU0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbZKJU0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:26:44 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:52224 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972AbZKJU0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:26:43 -0500
Subject: Re: sunrpc port allocation and IANA reserved list
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF9B2CF.6050305@nortel.com>
References: <4AF9A63B.6010101@nortel.com>
	 <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>
	 <4AF9B2CF.6050305@nortel.com>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 05:26:39 +0900
Message-Id: <1257884799.3044.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 1829 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 1E4822C2B4AE9FCC79542E73516D6B31FEE4E582
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 34 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 12:37 -0600, Chris Friesen wrote:
> On 11/10/2009 11:53 AM, Ben Hutchings wrote:
> > On Tue, 2009-11-10 at 11:43 -0600, Chris Friesen wrote:
> 
> >> Given that a userspace application can be stopped and restarted at any
> >> time, and a sunrpc registration can happen at any time, what is the
> >> expected mechanism to prevent the kernel from allocating a port for use
> >> by sunrpc that reserved or well-known?
> >>
> >> Apparently Redhat and Debian have distro-specific ways of dealing with
> >> this, but is there a standard solution?  Should there be?
> >>
> >> The current setup seems suboptimal.
> > 
> > I believe both RH and Debian are using the same implementation:
> > <http://cyberelk.net/tim/software/portreserve/>.
> 
> That helps with the startup case, but still leaves a possible hole if an
> app using a fixed port number is restarted at runtime.  During the
> window where nobody is bound to the port, the kernel could randomly
> assign it to someone else.

Just use /proc/sys/sunrpc/{max,min}_resvport interface to restrict the
range used to a safer one. That's what it is for...

Trond

