Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYJQA4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYJQA4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYJQAzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:55:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbYJQAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:55:52 -0400
Date: Thu, 16 Oct 2008 17:54:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Message-Id: <20081016175449.4ba7ac02.akpm@linux-foundation.org>
In-Reply-To: <200810161744.34005.david-b@pacbell.net>
References: <200810160845.22281.david-b@pacbell.net>
	<20081016161718.e05864da.akpm@linux-foundation.org>
	<200810161744.34005.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 17:44:33 -0700 David Brownell <david-b@pacbell.net> wrote:

> On Thursday 16 October 2008, Andrew Morton wrote:
> > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > We can get the following oops from gpio_get_value_cansleep()
> > > when a GPIO controller doesn't provide a get() callback:
> > 
> > We can, but do we? ;)
> 
> I think it's unlikely without the sysfs interface.
> 
> 
> > iow: is this needed in any -stable release?
> 
> The bug has been there since 2.6.25 but nobody else seems
> to have reported it.  Is the general policy to fix all
> oopses that *could* appear?  I'd send it for 2.6.27-stable,
> since that's got the sysfs hooks.  And older kernels if
> bug likelihood isn't a major concern.

OK.  2.6.27 definitely (major distros are basing on that).

As for earlier kernels: I'd say so.  An oops is farily serious. 
Although an oops in a sysfs handler tends to be fairly tame, as the
code usually doesn't hold locks or many allocated resources.

Anyway - making decisions like this is why we pay stable@kernel.org the
big bucks :)
