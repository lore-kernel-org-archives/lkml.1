Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928Ab0ASNST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0ASNST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624Ab0ASNSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:18:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:6774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0ASNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oU6cwom3PUTl1gHNq8dMXLaqbVNWp9uKzMBVp4BZYRbcMkFfj889OO2/m+T3nKhHu4
         ohS7SuP+nhNm+sBDtel506xqXWda/nqBnJ1oYdpGvdQYfrLxnAbphU+fjDMyzr1F8krM
         Z/vHLwt9CvVnfnZUXYqa4tPNJIzu1zKSFkl5g=
MIME-Version: 1.0
In-Reply-To: <1263905332.2163.11.camel@barrios-desktop>
References: <20100118141938.GI30698@redhat.com>
	 <20100118181942.GD22111@redhat.com>
	 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	 <20100119071734.GG14345@redhat.com>
	 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
	 <20100119075205.GI14345@redhat.com>
	 <84144f021001190007q54a334dfwed64189e6cf0b7c4@mail.gmail.com>
	 <20100119082638.GK14345@redhat.com>
	 <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
	 <1263905332.2163.11.camel@barrios-desktop>
Date: Tue, 19 Jan 2010 15:18:11 +0200
X-Google-Sender-Auth: 462d10fb89b9b267
Message-ID: <84144f021001190518x450868eax2edfa5e16ff6e4b@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 2:48 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Gleb. How about using MADV_SEQUENTIAL on guest memory?
> It makes that pages of guest are moved into inactive reclaim list more
> fast. It means it is likely to swap out faster than other pages if it
> isn't hit during inactive list.

Yeah, something like that but we don't want the readahead. OTOH, it's
not clear what Gleb's real problem is. Are the guest address spaces
anonymous or file backed? Which parts of the emulator are swapped out
that are causing the problem? Maybe it's a VM balancing issue that
mlock papers over?

                         Pekka
