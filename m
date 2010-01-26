Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570Ab0AZNDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0AZNDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154Ab0AZNDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:03:09 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:61015 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0AZNDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Mv78aionyhezKME6KC7ZOKyA4U0C2UU+F4oPcH0gJzyrA4CTkRJjj1dpIinRHr2C1y
         n0uuppNo8SEUQcNO1I5rRClN69UHynRqrKc/WY+M/+ssl6/V0x8mVuChVlO0e3SRkyna
         iobw23VJp0+6av6hH5laFZyI5FjS55z88NTAk=
MIME-Version: 1.0
In-Reply-To: <89k77n$mrr1hi@fmsmga001.fm.intel.com>
References: <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
	 <op.u64t84zuasvm2a@kedge>
	 <20100126183412.6AC9.A69D9226@jp.fujitsu.com>
	 <89k77n$mrr1hi@fmsmga001.fm.intel.com>
Date: Tue, 26 Jan 2010 22:03:06 +0900
X-Google-Sender-Auth: 58307c24608c7d8a
Message-ID: <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Roman Jarosz <kedgedev@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This comment is lie. __GFP_NORETY cause ENOMEM to shmem, not GEM itself.
>> GEM can't handle nor recover it. I suspect following commit is wrong.
>
> Indeed, the NORETRY flag is required for the inode mapping routines to
> return ENOMEM instead of triggering the OOM killer themselves. GEM has
> code to handle the ENOMEM as returned from shmem (please at least read the
> code before commenting, and comments are appreciated), by attempting to
> free up some of its own inactive buffers before retrying the allocation
> (with NORETRY removed, so the OOM killer will be invoked on the second
> instance). The reason for this convoluted approach is that GEM's inactive
> list shrinker requires the struct mutex and so cannot be run when GEM
> itself is attempting and failing to allocate memory. We could recover from
> more situations if we made some more invasive changes to our locking.
>
> This is without a doubt an area that needs improvement.

Please consider to revert such commit at once. Lots people reported
the same issue.
I really hope to stop bug report storm.
