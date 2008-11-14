Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYKNPYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYKNPYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYKNPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:24:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:33488 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYKNPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BlPd+TL76sCvULDQyKrEhiqQsPz1lgeuiTgSPbLwqoR10jXk6QROAGpbIJgEFopjRz
         iwmHJvS2v2Ip+3phwqqsk3Uw7k4kb1gyKnaXJJk5FfnU59Ff41qLyXns4i5uoHnZjnGB
         d9a96vFiO6pCZF6SfFKWuHun4eSAr7o7maueQ=
Message-ID: <517f3f820811140724x43fcc114o434b384fbeb6449e@mail.gmail.com>
Date: Fri, 14 Nov 2008 10:24:06 -0500
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] reintroduce accept4
Cc: subrata@linux.vnet.ibm.com, linux-arch@vger.kernel.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-api@vger.kernel.org, linux-man@vger.kernel.org,
       davidel@xmailserver.org, netdev@vger.kernel.org, roland@redhat.com,
       oleg@tv-sign.ru, hch@lst.de, davem@davemloft.net, alan@redhat.com,
       jakub@redhat.com
In-Reply-To: <20081113140541.23754cad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	 <517f3f820811131351l1305b2d2u43ab4e0601d97f93@mail.gmail.com>
	 <20081113140541.23754cad.akpm@linux-foundation.org>
X-Google-Sender-Auth: 0ad8693f038373c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Andrew, you noted a lack of explanation accompanying the original
>> patch.  Here's something to fill the gap, and which may be suitable
>> for the changelog.
>>
>> ==
>> Introduce a new accept4() system call.  The addition of this system
>> call matches analogous changes in 2.6.27 (dup3(), evenfd2(),
>> signalfd4(), inotify_init1(), epoll_create1(), pipe2()) which added
>> new system calls that differed from analogous traditional system calls
>> in adding a flags argument that can be used to access additional
>> functionality. The accept4() system call is exactly the same as
>> accept(), except that it adds a flags bit-mask argument.  Two flags
>> are initially implemented.  (Most of the new system calls in 2.6.27
>> also had both of these flags.)  SOCK_CLOEXEC causes the close-on-exec
>> (FD_CLOEXEC) flag to be enabled for the new file descriptor returned
>> by accept4().  This is a useful security feature to avoid leaking
>> information in a multithreaded program where one thread is doing an
>> accept() at the same time as another thread is doing a fork() plus
>> exec().  (More details here:
>> http://udrepper.livejournal.com/20407.html "Secure File Descriptor
>> Handling", Ulrich Drepper)  The other flag is SOCK_NONBLOCK, which
>> causes the O_NONBLOCK flag to be enabled on the new open file
>> description created by accept4().  (This flag is merely a convenience,
>> saving the use of additional calls fcntl(F_GETFL) and fcntl (F_SETFL)
>> to achieve the same result.)
>
> I replaced the existing changelog with the above (plus some paragraph
> breaks ;)).  Will add the new test app when it comes along.

Git allows paragraph breaks in changelogs?!  You gotta love technology ;-).

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
