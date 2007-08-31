Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXHaIVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXHaIVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbXHaIU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:20:58 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:39330 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbXHaIU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:20:57 -0400
X-Greylist: delayed 1815 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 04:20:56 EDT
Date: Fri, 31 Aug 2007 09:50:32 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
Message-ID: <20070831075032.GA13159@citd.de>
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <001001c7eb57$afd2d320$0f787960$@com> <1188516173.6626.46.camel@heimdal.trondhjem.org> <001501c7eb5d$d295d870$77c18950$@com> <1188517070.6626.54.camel@heimdal.trondhjem.org> <001601c7eb5f$b6146980$223d3c80$@com> <1188534682.6626.70.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188534682.6626.70.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's not very conservative to suddenly change default behavior and break
> > autofs mounts. There is not even one kernel message that "_tells_ user why
> > it thinks it's wrong". It just silently fails.
> 
> No it doesn't. It reports an error code to the caller. If autofs is
> failing silently, then that is a bug in autofs: mount will report the
> error to the user.

Wrong(tm).

autofs AND mounting at the commandline just say:
mount.nfs: /mnt is already mounted or busy

Which has an actual information value of about 1%.

In my case i moved a nfs exported directory inside another nfs-exported 
directory month ago and placed a symlink where the direcotry was (on the 
server-side). It never acured to me that that was "wrong"(tm).

Now i can only mount one of the two mounts and the other just tells 
"busy".

After reading this i could fix my case easyly. I just erased the 
"deeper" mount and symlinked the directory from the other mount.

But YOU HAVE TO KNOW THAT YOU DID SOMETHING WRONG. Just getting a "Busy" 
lets you staying with Question-marks flying around you head!




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

