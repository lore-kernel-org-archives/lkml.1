Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZEJN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZEJN4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZEJN42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:56:28 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:59819 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZEJN42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jhUoh3vlasWXdFSFL7kNjfadkC0R2c40AHj50uJSMr0yDF0vEQrF7UyGjeRNag9t1h
         YIxZd1t+Q9fLqqEKeirp57CVz06A2q3Q+P/tD4bQ1yNckoBD/R1nfP82jWscMHcfTmmL
         G4hky7Al767NRhQDKc/S+oz9U2feeJ9vN0m+4=
MIME-Version: 1.0
In-Reply-To: <20090510144533.167010a9@lxorguk.ukuu.org.uk>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090507151039.GA2413@cmpxchg.org>
	 <20090507134410.0618b308.akpm@linux-foundation.org>
	 <20090508081608.GA25117@localhost>
	 <20090508125859.210a2a25.akpm@linux-foundation.org>
	 <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <1241946446.6317.42.camel@laptop>
	 <2f11576a0905100236u15d45f7fm32d470776659cfec@mail.gmail.com>
	 <20090510144533.167010a9@lxorguk.ukuu.org.uk>
Date: Sun, 10 May 2009 22:56:27 +0900
X-Google-Sender-Auth: 734bd1fc192ee95c
Message-ID: <2f11576a0905100656x51386193tb28e169651c3522d@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       linux-mm@kvack.org, elladan@eskimo.com, npiggin@suse.de,
       cl@linux-foundation.org, minchan.kim@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


>> I don't oppose this policy. PROT_EXEC seems good viewpoint.
>
> I don't think it is that simple
>
> Not only can it be abused but some systems such as java have large
> PROT_EXEC mapped environments, as do many other JIT based languages.

hmm
I don't think this patch change JIT behavior.
JIT makes large executable _anon_  pages. but page_mapping(anon-page)
return NULL.

Thus, the logic do nothing.


> Secondly it moves the pressure from the storage volume holding the system
> binaries and libraries to the swap device which already has to deal with
> a lot of random (and thus expensive) I/O, as well as the users filestore
> for mapped objects there - which may even be on a USB thumbdrive.

true.
My SSD have high speed random reading charactastics.

> I still think the focus is on the wrong thing. We shouldn't be trying to
> micro-optimise page replacement guesswork - we should be macro-optimising
> the resulting I/O performance. My disks each do 50MBytes/second and even with the
> Gnome developers finest creations that ought to be enough if the rest of
> the system was working properly.

Yes, mesurement is essential.
