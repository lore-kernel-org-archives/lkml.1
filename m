Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYAJAs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYAJAs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYAJAsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:48:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:51855 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYAJAsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hSnZNd7ZJW46pZ3Q1vsaKyXvm7VaupVBjFaHLS7M7fNSybdCpBpVHJMxwXKXRtlVnfzW8OXY4RwY7FPCtbids88YCDB+tkNeVKPwIbCujStyTzX1C5gwm5rbHerOx80lkuQsPqg5tY3B0qWoIosU3xi/KlW0SFkrr9y20MYMRkA=
Message-ID: <4df4ef0c0801091648h76ef78fel5b04faafc2ed94df@mail.gmail.com>
Date: Thu, 10 Jan 2008 03:48:49 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Cc: Valdis.Kletnieks@vt.edu, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080109170633.292644dc@cuia.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
	 <26932.1199912777@turing-police.cc.vt.edu>
	 <20080109170633.292644dc@cuia.boston.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/10, Rik van Riel <riel@redhat.com>:
> On Wed, 09 Jan 2008 16:06:17 -0500
> Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 09 Jan 2008 15:50:15 EST, Rik van Riel said:
> >
> > > Could you explain (using short words and simple sentences) what the
> > > exact problem is?
> >
> > It's like this:
> >
> > Monday  9:04AM:  System boots, database server starts up, mmaps file
> > Monday  9:06AM:  Database server writes to mmap area, updates mtime/ctime
> > Monday <many times> Database server writes to mmap area, no further update..
> > Monday 11:45PM:  Backup sees "file modified 9:06AM, let's back it up"
> > Tuesday 9:00AM-5:00PM: Database server touches it another 5,398 times, no mtime
> > Tuesday 11:45PM: Backup sees "file modified back on Monday, we backed this up..
> > Wed  9:00AM-5:00PM: More updates, more not touching the mtime
> > Wed  11:45PM: *yawn* It hasn't been touched in 2 days, no sense in backing it up..
> >
> > Lather, rinse, repeat....
>
> On the other hand, updating the mtime and ctime whenever a page is dirtied
> also does not work right.  Apparently that can break mutt.

Please tell why you think that can break mutt? Such approach was
suggested by Peter once and looks reasonable to me too.

>
> Calling msync() every once in a while with Anton's patch does not look like a
> fool proof method to me either, because the VM can write all the dirty pages
> to disk by itself, leaving nothing for msync() to detect.  (I think...)
>
> Can we get by with simply updating the ctime and mtime every time msync()
> is called, regardless of whether or not the mmaped pages were still dirty
> by the time we called msync() ?
>
> --
> All Rights Reversed
>
