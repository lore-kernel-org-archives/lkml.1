Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXLIFW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXLIFW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXLIFWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:22:51 -0500
Received: from 1wt.eu ([62.212.114.60]:2622 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbXLIFWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:22:50 -0500
Date: Sun, 9 Dec 2007 06:21:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: Theodore Tso <tytso@mit.edu>,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071209052149.GH15227@1wt.eu>
References: <20071204114125.GA17310@torres.zugschlus.de> <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de> <200712090010.10362.ismail@pardus.org.tr> <20071208234612.GQ17037@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071208234612.GQ17037@thunk.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 06:46:12PM -0500, Theodore Tso wrote:
> On Sun, Dec 09, 2007 at 12:10:10AM +0200, Ismail Dönmez wrote:
> > > As long as /dev/random is readable for all users there's no reason to
> > > use /dev/urandom for a local DoS...
> > 
> > Draining entropy in /dev/urandom means that insecure and possibly not random 
> > data will be used and well thats a security bug if not a DoS bug.
> 
> Actually in modern 2.6 kernels there are two separate output entropy
> pools for /dev/random and /dev/urandom.  So assuming that the
> adversary doesn't know the contents of the current state of the
> entropy pool (i.e., the RNG is well seeded with entropy), you can read
> all you want from /dev/urandom and that won't give an adversary
> successful information to attack /dev/random.

Wouldn't it be possible to mix the data with the pid+uid of the reading
process so that even if another one tries to collect data from urandom,
he cannot predict what another process will get ? BTW, I think that the
tuple (pid,uid,timestamp of open) is unpredictable and uncontrollable
enough to provide one or even a few bits of entropy by itself.

Regards,
Willy

