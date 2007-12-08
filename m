Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbXLHXqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbXLHXqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXLHXqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:46:43 -0500
Received: from THUNK.ORG ([69.25.196.29]:37296 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbXLHXqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:46:42 -0500
Date: Sat, 8 Dec 2007 18:46:12 -0500
From: Theodore Tso <tytso@mit.edu>
To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208234612.GQ17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de> <200712090010.10362.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712090010.10362.ismail@pardus.org.tr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 12:10:10AM +0200, Ismail Dönmez wrote:
> > As long as /dev/random is readable for all users there's no reason to
> > use /dev/urandom for a local DoS...
> 
> Draining entropy in /dev/urandom means that insecure and possibly not random 
> data will be used and well thats a security bug if not a DoS bug.

Actually in modern 2.6 kernels there are two separate output entropy
pools for /dev/random and /dev/urandom.  So assuming that the
adversary doesn't know the contents of the current state of the
entropy pool (i.e., the RNG is well seeded with entropy), you can read
all you want from /dev/urandom and that won't give an adversary
successful information to attack /dev/random.

							- Ted
