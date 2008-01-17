Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYAQBR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYAQBR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYAQBRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:17:38 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:39089 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbYAQBRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=maxKZKaYhB9a2/2kysIEcBxAp8lNRi89XQxez2gxx5FckQkM6OHfYhPGo4HaeB4hWzJJVZ3Woew+AwW5DUi3JOm6uG+djHkFGBBVGW0IMppGpz6sA6ZrcSO2gcZ+p+YXmQYtBGlUDfRZjr9pl9Asreb5Qz4JpJKdkOXmIQnl3EQ=
Message-ID: <a8e1da0801161717r4cdc1e9cn6a8ec1731c8f831b@mail.gmail.com>
Date: Thu, 17 Jan 2008 09:17:35 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20080116083442.GA2307@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112100515.GA2956@darkstar.te-china.tietoenator.com>
	 <20080115091527.GB3186@darkstar.te-china.tietoenator.com>
	 <20080115135604.GD1696@ff.dom.local>
	 <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com>
	 <20080116083442.GA2307@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 4:34 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Wed, Jan 16, 2008 at 09:03:03AM +0800, Dave Young wrote:
> ...
> > The lockdep warining was posted in the below thread, actually, I have
> > built and run this patced kernel for several days, there's no more
> > warnings.
> > http://lkml.org/lkml/2008/1/3/2
>
> Right... But, with something like this:
>
> ... have_some_fun(... cls)
> {
>         mutex_lock_nested(&cls->mutex, SINGLE_DEPTH_NESTING);
>         have_other_fun(cls);
>         mutex_unlock(&cls->mutex);
>
> }
>
> ... have_more_fun(...)
> {
>         ...
>
>         mutex_init(&cls->mutex);
>
>         mutex_lock(&cls->mutex);
>         have_some_fun(cls);
>         mutex_unlock(&cls->mutex);
> }
>
> probably you wouldn't get any lockdep warning too...

Sorry for late reply.
Actually, I don't know much about lockdep. Could you tell how to use
it properly in this scenario?

>
> Of course, if we know all the locking is right such proper lockdep
> annotating shouldn't matter too much. (And of course this could be
> improved later.)
>
> Regards,
> Jarek P.
>
