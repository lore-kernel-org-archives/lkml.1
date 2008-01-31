Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYAaBnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYAaBnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYAaBnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:43:14 -0500
Received: from minbar.dodds.net ([66.93.39.86]:44275 "EHLO minbar.dodds.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYAaBnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:43:13 -0500
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 20:43:13 EST
Date: Wed, 30 Jan 2008 17:34:15 -0800
From: Steve Langasek <vorlon@debian.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: sfrench@samba.org, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Subject: Re: [2.6 patch] remove smbfs
Message-ID: <20080131013415.GA3768@dario.dodds.net>
References: <20080128220835.GF8767@does.not.exist> <200801302216.13788.linux@kukkukk.com> <20080130174103.17ff8197@tleilax.poochiereds.net> <20080130225810.GU29368@does.not.exist> <20080130193412.61c6e2e9@tleilax.poochiereds.net> <20080131004717.GX29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131004717.GX29368@does.not.exist>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 02:47:17AM +0200, Adrian Bunk wrote:
> > smbfs has the unfortunate quality of momentum. A lot of users aren't
> > aware of CIFS at all since smbfs basically does what they need it to
> > do. Some extra warning for those users would be nice.

> And many users will start whining loudly that the not deprecated driver 
> (in this case cifs) has this or that bug not before the patch to finally 
> remove the deprecated feature got applied or at least posted.

> And will demand that it therefore does not get removed.

We've had about 3 of these in Debian since deciding to cut it from the
upcoming release.  (The kicker for us was the samba security update that
wasn't tested with smbfs as a client.)  The key regressions of interest
relative to smbfs seem to be:

- lack of DFS support
- lack of netbios name resolution for UNC share names

The former seems to be a kernel issue whose resolution is in progress, and I
think the latter would have to be addressed in the userspace mount tools?

-- 
Steve Langasek                   Give me a lever long enough and a Free OS
Debian Developer                   to set it on, and I can move the world.
Ubuntu Developer                                    http://www.debian.org/
slangasek@ubuntu.com                                     vorlon@debian.org
