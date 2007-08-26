Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbXHZQOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbXHZQOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXHZQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:14:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:6529 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbXHZQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BmD5Vk11B0ZWKqxKeFD8dzRwrA7NsTU3Ehv+Avlk9BHjLPupvz7Z5/pNRpvZhh4xfpuh9g6syhDAZTBouMrckIubYIq1LNiWRKMSs84h3q8yxg8fYRyC7StrGXqREZ2a9wRruV6Vay77QnFMpSG1nWbJ5HUQa4u0DVreXu2JthQ=
Message-ID: <466ad3f90708260914v7d11ebc2s8025ea5d549683dd@mail.gmail.com>
Date: Sun, 26 Aug 2007 12:14:40 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260914g3cb92f30q8d5672e3f9cf960c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
	 <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com>
	 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr>
	 <466ad3f90708260914g3cb92f30q8d5672e3f9cf960c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Fred Tyler <fredty8@gmail.com> wrote:
> On 8/26/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> > On Aug 26 2007 11:51, Fred Tyler wrote:
> > >On 8/26/07, Fred Tyler <fredty8@gmail.com> wrote:
> > >> I think I've come across a memory leak in 2.6.20. I've upgraded to the
> > >> latest 2.6.20.17, but it didn't seem to help.
> > >
> > >Sorry to keep replying to my own post, but further investigation
> > >suggests that the memory losses may be occurring at times of heavy
> > >filesystem access. The machines in question run rsyncs of hundreds of
> > >thousands of files every few hours, and I'm starting to think that the
> > >memory loss occurs during these times. I don't know how I'd go about
> > >proving this though...
> >
> > Please rule out filesystem caches by issuing
> >         sync;
> >         echo 3 >/proc/sys/vm/drop_caches;
>
>
> Ok, I did this on a non-production machine that has only been up for a
> few hours, and here's what happened:
>
> ======== Before =========
>
> $ free -m
>              total       used       free     shared    buffers     cached
> Mem:           878        824         54          0        111        422
> -/+ buffers/cache:        290        587
> Swap:           63          0         63
>
>
> ======== After ========
>
> root@b0$ free -m
>              total       used       free     shared    buffers     cached
> Mem:           878         47        830          0          6          4
> -/+ buffers/cache:         36        841
> Swap:           63          0         63
>
> ======================
>
> So, I guess it worked? (I don't know what was supposed to happen, but
> memory usage dropped significantly when I did this.)
>
> However, I'm not sure this staging machine has been up long enough or
> doing enough to exhibit the problem. I can try this on my production
> servers (the ones I provided graphs for) late tonight, but how safe is
> running this command? Does it permanently disable file caching? Do I
> need to reset it afterwards? If I stop all services (databases,
> logging, etc) first, am I protected against data loss?
>
