Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZEBBjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZEBBjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZEBBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:39:12 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:51601 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZEBBjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:39:11 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 May 2009 21:39:10 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fe4l/BNreqqOwwR/G2I0zk9HcLATDahvcWSIt17FJFHjbzQFdgekwRfmYAM+6Jtn5q
         oAbOMiJ8mvWIQYPtKBbFIpArCsKVcWUa0u/JUo6cRWRwYuadpNh50tIVAO8IKdAEthrU
         UTV0quabgNZwKaixZbV48WYBHiJwAzbBmewWc=
Date: Sat, 2 May 2009 03:39:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/6] kill-the-BKL/reiserfs3: performance improvements,
	faster than Bkl based scheme
Message-ID: <20090502013906.GA5331@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 04:44:16AM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> This reiserfs patchset applies against latest tip:core/kill-the-BKL
> It adds various explicit write lock releases on specific sleeping sections.
> 
> A performance test with dbench on UP with 100 processus during 100 seconds
> gives the following results:
> 
> Locking		  Throughput 
> 
> Bkl:              11.2587 MB/s
> Write lock/Mutex: 12.5713 MB/s


I just tested on SMP with two CPU:

Write Lock/Mutex: Throughput 66.9269 MB/sec 100 procs
Bkl:              Throughput 71.9998 MB/sec 100 procs

So:

UP:  11% faster
SMP:  8% slower


I guess there is still some work to do :)

