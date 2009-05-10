Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZEJPAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZEJPAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZEJO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 10:59:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:58233 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbZEJO7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 10:59:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HVT0J0Q5yEgc1FsKrVKA7xq0PGG+8wkOUnZf/pW/1pPo8Ecdtu9KM+Siw6dAhVyRqf
         MVZQjqHvpHG9PmwHBfeH+CP2MJiqwiwJzp5VLqwxtjFAumjTxyrlcWFBUjcn83RSTO0D
         R7i1ypKgMY80l/Sqgvn3Y/W0qCJcRHGnPBwIw=
MIME-Version: 1.0
In-Reply-To: <4A06EA08.1030102@redhat.com>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090507134410.0618b308.akpm@linux-foundation.org>
	 <20090508081608.GA25117@localhost>
	 <20090508125859.210a2a25.akpm@linux-foundation.org>
	 <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <1241946446.6317.42.camel@laptop>
	 <2f11576a0905100236u15d45f7fm32d470776659cfec@mail.gmail.com>
	 <20090510144533.167010a9@lxorguk.ukuu.org.uk>
	 <4A06EA08.1030102@redhat.com>
Date: Sun, 10 May 2009 23:59:54 +0900
X-Google-Sender-Auth: 1aad5aef50bfe482
Message-ID: <2f11576a0905100759n30fbc948wef34336774abfae1@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org,
       elladan@eskimo.com, npiggin@suse.de, cl@linux-foundation.org,
       minchan.kim@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> Secondly it moves the pressure from the storage volume holding the system
>> binaries and libraries to the swap device which already has to deal with
>> a lot of random (and thus expensive) I/O, as well as the users filestore
>> for mapped objects there - which may even be on a USB thumbdrive.
>
> Preserving the PROT_EXEC pages over streaming IO should not
> move much (if any) pressure from the file LRUs onto the
> swap-backed (anon) LRUs.

I don't think this is good example.
this issue is already solved by your patch. Thus this patch don't
improve streaming IO issue.
