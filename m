Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbXKNJN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbXKNJN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbXKNJNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:13:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:59941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbXKNJNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:13:15 -0500
Date: Wed, 14 Nov 2007 10:12:51 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: "Serge E. Hallyn" <sergeh@us.ibm.com>
Cc: "chris@friedhoff.org" <chris@friedhoff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Posix file capabilities in 2.6.24rc2
Message-Id: <20071114101251.a1f6214d.chris@friedhoff.org>
In-Reply-To: <20071113235318.GA6477@sergelap.austin.ibm.com>
References: <20071113230720.22c6a036.chris@friedhoff.org>
	<20071113235318.GA6477@sergelap.austin.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/o1ckD499DCU1ahvvam4UptntGUHQ42CKaq2e
 exC0TGdmpTYNi9J9vw1hrPRMszPEEYg+QOiUKeQmjt2MtT8/bN
 iKlFlLq7yHK/pp6DD/X6+qI0LF4FAoW
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Serge,

I wanted only to express what I observed.

A "yes it should" confirms its ok.

And yes, I haven't looked into the patches and the name and commentary
of file-capabilities-clear-fcaps-on-inode-change.patch explains this
already.
I'm preparing to update my page http://www.friedhoff.org/fscaps.html
for 2.6.24, and I also want to explain what one has to take into account
or be beware off. If I stumble about this, I think others will also
(imho).

I have written a script to change suid binaries and servers,
automating the examples I give on the webpage.
In the sequence of commands I was setting fscaps and than chown the
binary. Now with the aforementioned patch the fscaps are removed when
I chown and the script wasn't working anymore. My point is not my
script, it's being surprised and being a bit at a loss. Documenting
this helps to clarify things and users to adopt this feature.


The matter with "xinit:  Operation not permitted..." happens, when I
(unprivileged user) close a from a console started X session. Similar to
Andrew Morton'S http://lkml.org/lkml/2006/11/23/15 . The 2.6.24-rc2
kernel has capabilties enabled but /usr/bin/xinit has no capabilities
set. It remains the black screen with a cursor, the windowmanager is
closed. Is this known? Is this a problem? Does anyone else observes
this?
As far as I understand, I dont have to grant / to use capabilities even
when the kernel has capabilities enabled.


Chris


On Tue, 13 Nov 2007 17:53:18 -0600
"Serge E. Hallyn" <sergeh@us.ibm.com> wrote:

> Quoting Chris Friedhoff (chris@friedhoff.org):
> > Hello,
> > 
> > everything works as expected, but ...
> > 
> > closing X and no capabilities set for xinit does shutdown only the
> > windowmanager and not the X server (Xorg server 1.4)
> > Consolemessage is:
> > xinit:  Operation not permitted (errno 1): Can't kill X server
> > 
> > 
> > the xattr capability is removed, when the file is chown'ed.
> 
> Hi Chris,
> 
> yes on chown the capability is removed.  I'm not quite sure what
> you're asking?  Is your setup depending on being able to chown
> while keeping file capabilities?  Can you give some more details?
> 
> thanks,
> -serge


--------------------
Chris Friedhoff
chris@friedhoff.org
