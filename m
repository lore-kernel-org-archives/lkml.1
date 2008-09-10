Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYIJFDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYIJFDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYIJFDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:03:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYIJFDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:03:24 -0400
Date: Tue, 9 Sep 2008 22:01:12 -0700
From: Greg KH <greg@kroah.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit]
	and find_css_set
Message-ID: <20080910050112.GA2897@kroah.com>
References: <48AA684B.7000704@cn.fujitsu.com> <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com> <48C72E7C.8080302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C72E7C.8080302@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 10:18:36AM +0800, Lai Jiangshan wrote:
> Paul Menage wrote:
> > On Mon, Aug 18, 2008 at 11:29 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> > 2) Use atomic_inc_not_zero() in find_existing_css_set(), to ensure
> > that we only return a referenced css, and remove the get_css_set()
> > call from find_css_set(). (Possibly wrapping this in a new
> > kref_get_not_zero() function)
> > 
> 
> [CC: Greg Kroah-Hartman <greg@kroah.com>]
> 
> There are indeed several ways fix this race by Using the
> atomic-functions directly. I prefer the second one, i makes all
> code clearly. And put_css_set[_taskexit] do not need to be changed.
> 
> I don't think adding kref_get_not_zero() API is a good idea.
> It will bring kref APIs to a little chaos, kref_get_not_zero() is
> hard to be used, for this function needs a special lock held.
> 
> But I tried:

What are you trying to solve here with this change?  I agree, it does
seem a bit "chaotic" :)

I thought we used to have something like this for kref in the past, but
I must be mistaken as it's no longer there...

thanks,

greg k-h
