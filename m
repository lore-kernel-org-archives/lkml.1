Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbXFDNM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbXFDNM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXFDNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:12:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36049 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751943AbXFDNMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:12:49 -0400
Date: Mon, 4 Jun 2007 15:12:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070604131242.GE1971@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706041325.30817.agruen@suse.de> <20070604113519.GA6710@elf.ucw.cz> <200706041342.42178.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706041342.42178.agruen@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > You very well know that the vfs has a limit of PATH_MAX characters (4096)
> > > for pathnames. This means that at most that many characters can be passed
> > > at once.
> 
> What users can do is something like this:
> 
>   chdir("some/long/path");
>   chdir("some/even/longer/path");
>   ...
> 
> and the total length of the path can then exceed PATH_MAX characters. We can 
> only accept pathnames up to some upper limit, and we need to somehow define 
> what that limit is supposed to be. We could use PATH_MAX or some other 
> arbitrary number. In most situations PATH_MAX will be fine, but that's not 
> always guaranteed to be the case. So what's wrong about making this 
> configurable for special situations that we might run into? Module parameters 
> are *really* dead cheap.

Parameters are cheap, but this one is ugly.

How will kernel work with very long paths? I'd suspect some problems,
if path is 1MB long and I attempt to print it in /proc
somewhere. Perhaps vfs should be modified not to allow such crazy
paths? But placing limit in aa is ugly.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
