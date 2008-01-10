Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYAJUld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYAJUld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYAJUlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:41:22 -0500
Received: from havoc.gtf.org ([69.61.125.42]:43788 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbYAJUlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:41:20 -0500
Date: Thu, 10 Jan 2008 15:41:19 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Trond.Myklebust@netapp.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: major NFSv4 client regression (-rc7)
Message-ID: <20080110204119.GA714@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Server:		Linux 2.6.24-rc6 (x86-64/Fedora 8)
Good client:	Linux 2.6.24-rc6-ge697789d (x86-64/Fedora 7)
Bad client:	Linux 2.6.24-rc7-gfd0b45df (x86-64/Fedora 7)
Situation:	home dir via NFS

My home setup is a standard homedir-over-NFS setup, using NFSv4 on both
client and server.  I just rebooted into the latest upstream kernel, and
I am getting NFS client hangs all over the place:

	[jgarzik@core firefox]$ cat profiles.ini 

	hangs here, for 15 minutes so far and counting...
	('core' is the client machine)

and I first noticed this when firefox and thunderbird were hanging, when
I tried to start them after rebooting into the latest kernel.  stracing
firefox yielding a hang in open:

	("/g" is the NFS-mounted volume)

	access("/usr/lib64/firefox-2.0.0.10/updates", F_OK) = -1 ENOENT (No such file or directory)
	access("/g/g/.mozilla/firefox", F_OK)   = 0
	access("/g/g/.mozilla/firefox", F_OK)   = 0
	stat("/g/g/.mozilla/firefox/profiles.ini", {st_mode=S_IFREG|0664, st_size=94, ...}) = 0
	open("/g/g/.mozilla/firefox/profiles.ini", O_RDONLY

	hangs here, for 20 minutes so far and counting...

As you can see from the trace, and as I can report simply by being able
to send this message, SOME file accesses over NFS work just fine.

Accessing the file works when logged into the server, so its not disk
corruption or something like that.

Neither client nor server have anything interesting in dmesg -- in fact
nothing in dmesg beyond the normal boot messages have been printed.

Let me know what info I can provide...  This is a 100% reproducible
regression, and this latest NFS client revision has made my local
NFS-over-homedir setup completely unusable.  I am forced to return to
the known working client (Linux 2.6.24-rc6-ge697789d) just to run basic
apps.

	Jeff



