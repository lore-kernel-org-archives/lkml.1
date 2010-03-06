Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0CFSc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 13:32:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0CFScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 13:32:55 -0500
Date: Sat, 6 Mar 2010 18:32:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "Switch !O_CREAT case to use of do_last()" causes segfault in
 glibc
Message-ID: <20100306183254.GG30031@ZenIV.linux.org.uk>
References: <4B92944E.8080209@gmail.com>
 <20100306175917.GD30031@ZenIV.linux.org.uk>
 <20100306180313.GE30031@ZenIV.linux.org.uk>
 <4B929CF9.8010506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B929CF9.8010506@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 10:20:41AM -0800, walt wrote:
> On 03/06/2010 10:03 AM, Al Viro wrote:
> 
> >_Really_ interesting; it doesn't look like an oops - smells like an attempt
> >to do opendir() that fails for some reason, goes unnoticed and resulting
> >FILE * (i.e. NULL) is fed to readdir()?
> >
> >What does it attempt to open?
> 
> Ah, this may help:
> 
> open("/usr/share/zoneinfo/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 47
> open("/usr/share/zoneinfo/MST7MDT", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 48

Now that is interesting.  Looks like it has managed to lose O_DIRECTORY check
in the open without trailing slash and (properly) barfed with / added.
