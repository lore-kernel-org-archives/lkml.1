Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbXHaFZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbXHaFZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXHaFZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:25:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:59028 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXHaFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=E1wddjR39gKnEwhEKn4Rry/EiRgqYuOWVDKUO/E4mQmMtD2zkNRiyNF4Ae8T3kWvaIJ4NDwwghn7EnvtTFzwsiNLIPpTuthKdZinKQlkNfi3qqyYYbPvVc77O37qz23XI1fT0ROtKZVZ9EHIEj7Q5XFr02yqySaS7pMlKfB5Jko=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'Frank van Maarseveen'" <frankvm@frankvm.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>	 <1188535485.6626.85.camel@heimdal.trondhjem.org>	 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org> <1188536658.6626.98.camel@heimdal.trondhjem.org>
In-Reply-To: <1188536658.6626.98.camel@heimdal.trondhjem.org>
Subject: RE: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 22:24:56 -0700
Message-ID: <002201c7eb8f$463704d0$d2a50e70$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfrjGVAnnGwBHw2Q1adZlMgPjSj3AAAdkqw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond,

> So you are saying that it is acceptable for the kernel to decide
> unilaterally to override mount options? Why aren't we doing that for
> any other filesystem than NFS?

I think there are two reasons.

First, I have no problem with the new behavior if it didn't cause a
regression. I am not sure about the history of other filesystems, but NFS
has had the old behavior for ages, and people get used to it.

Second, NFS is actually special as this particular setup is very common and
you'll get into this situation far too easily, as from the server you could
export two directories within a filesystem as if they were two filesystems.
Very few people actually want to mount the same local filesystem multiple
times, but under NFS this is the norm.

Last but not the least, NFS is often controlled by central corporate
policies (autofs/nis), and has to work with various clients. For example,
it's not possible to add "nosharecache" to auto.auto as almost nobody
understands it, unless you upgrade all the clients.

> Trond

