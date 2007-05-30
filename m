Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbXE3PlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbXE3PlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXE3Pkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:40:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXE3Pkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:40:53 -0400
Message-ID: <465D9A97.40507@redhat.com>
Date: Wed, 30 May 2007 08:39:03 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu>
In-Reply-To: <20070530084252.GA15708@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> we should perhaps enable glibc to have its separate fd namespace (or 
> 'hidden' file descriptors at the upper end of the fd space) so that it 
> can transparently listen to netlink events (or do epoll),

Something like this would only work reliably if you have actual
protection coming with it.  Also, there are still reasons why an
application might want to see, close, handle, whatever these descriptors
in a separate namespace.

I think such namespaces are a broken concept.  How many do you want to
introduce?  Plus, then you get away from the normal file descriptor
interfaces anyway.  If you'd represent these alternative namespace
descriptors with ordinary ints you gain nothing.  You'd have to use
tuples (namespace,descriptor) and then you need a whole set of new
interfaces or some sticky namespace selection which will only cause
problems (think signal delivery).


> without 
> impacting the application fd namespace - instead of ducking to a memory 
> based API as a workaround.

It's not "ducking".  Memory mapping is one of the most natural
interfaces.  Just because Unix/Linux is built around the concept of file
descriptors does not mean this is the ultimate in usability.  File
descriptors are in fact clumsy: if you have a file descriptor to read
and write data, all auxiliary data for that communication must be
transferred out-of-band (e.g, fcntl) or in very magical and hard to use
ways (recvmsg, sendmsg).  With a memory based event mechanism this
auxiliary data can be stored in memory along with the event notification.



> it is a serious flexibility issue that should not be ignored. The 
> unified fd space is a blessing on one hand because it's simple and 

Too simple.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXZqX2ijCOnn/RHQRAsSFAKCNrd8/sRss1wBA9hkpnYIeALDbXQCfRNAb
yZy2Nofz2CgDo9PQYK3C/bo=
=klUJ
-----END PGP SIGNATURE-----
