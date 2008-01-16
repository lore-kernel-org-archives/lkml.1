Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYAPROq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYAPROq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbYAPRNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:13:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbYAPRNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:13:21 -0500
Message-ID: <478E3B00.1030503@redhat.com>
Date: Wed, 16 Jan 2008 17:12:32 +0000
From: "Bryn M. Reeves" <breeves@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 04/27] kill filp_open()
References: <20071101230826.9A4F6E00@kernel>	 <20071101230831.904FDE9A@kernel>	 <20080116005200.0165dc67.akpm@linux-foundation.org> <1200503096.22674.171.camel@localhost>
In-Reply-To: <1200503096.22674.171.camel@localhost>
X-Enigmail-Version: 0.94.0.0
OpenPGP: id=C61463DE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dave Hansen wrote:
> On Wed, 2008-01-16 at 00:52 -0800, Andrew Morton wrote:
>> On Thu, 01 Nov 2007 16:08:31 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:
>>> Replace all callers with open_namei() directly, and move the
>>> nameidata stack allocation into open_namei().
>> ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop.patch
>> is using filp_open() and hence doesn't work very well.
>>
>> A shall revert dm-loop.patch and run away.
> 
> This one's pretty easy, thank goodness.  Just replace filp_open() with
> open_namei():
> 
> 	/filp_open(/open_namei(AT_FDCWD, /
> 
> BTW, why do we need this on top of the existing loopback driver?  Can
> they really share no code?

The current dm-loop patch was really written to demonstrate the value of
block-mapping as an alternative to doing file backed I/O via the pagecache.

Personally, I would like to see a single "loopback block devices" driver
in the kernel with loop.c and dm-loop as alternate interfaces to it.

There seems to be some demand for this, e.g.:

http://bugzilla.kernel.org/show_bug.cgi?id=5333

And numerous similar posts to dm-devel (although I think obsoleting may
be going a bit far to start with!).

Regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHjjsA6YSQoMYUY94RAv+fAJ90mbqDQ/17nd3j9OAIXXc8Y4SRbQCfR75I
KtDxHXDnYmCmBlw/lOzGmms=
=A+Vb
-----END PGP SIGNATURE-----
