Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbXLIMcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbXLIMcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXLIMcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:32:16 -0500
Received: from thunk.org ([69.25.196.29]:41471 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLIMcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:32:15 -0500
Date: Sun, 9 Dec 2007 07:31:47 -0500
From: Theodore Tso <tytso@mit.edu>
To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071209123147.GZ17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <200712090010.10362.ismail@pardus.org.tr> <20071208234612.GQ17037@thunk.org> <200712090821.16483.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712090821.16483.ismail@pardus.org.tr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 08:21:16AM +0200, Ismail Dönmez wrote:
> My understanding was if you can drain entropy from /dev/urandom any futher 
> reads from /dev/urandom will result in data which is not random at all. Is 
> that wrong?

Past a certain point /dev/urandom will stat returning results which
are cryptographically random.  At that point, you are depending on the
strength of the SHA hash algorithm, and actually being able to not
just to find hash collisions, but being able to trivially find all or
most possible pre-images for a particular SHA hash algorithm.  If that
were to happen, it's highly likely that all digital signatures and
openssh would be totally broken.

						- Ted
