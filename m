Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZCYWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZCYWqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZCYWqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:46:07 -0400
Received: from ozlabs.org ([203.10.76.45]:60707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCYWqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:46:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nikanth Karthikesan <knikanth@novell.com>
Subject: Re: Strange code in include/linux/cpumask.h
Date: Thu, 26 Mar 2009 09:14:46 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: nikanth@gmail.com, linux-kernel@vger.kernel.org
References: <200903251021.13811.knikanth@novell.com> <200903251541.12180.rusty@rustcorp.com.au> <200903251214.31731.knikanth@novell.com>
In-Reply-To: <200903251214.31731.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903260914.46958.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 17:14:30 Nikanth Karthikesan wrote:
> On Wednesday 25 March 2009 10:41:11 Rusty Russell wrote:
> > Yes, except that this insists that bitmap be an unsigned long * or you'll
> > get a warning.  Otherwise the macro could be used on anything.  And it
> > needs to be a macro to use it as a static initializer.
> 
> Ah, got it. Thanks a lot for the explanation. May be a comment could be added 
> to the source.

Well, it's not that unusual a trick in the kernel, but an explanation might
help.

> Also looks like, this is not being used as a static initializer anywhere. 
>  i.e., Using my type-checking only version didn't trigger any error/warnings! 

It will.  cpu_all_mask uses to_cpumask, and it's replacing CPU_MASK_ALL.

> Being a deprecated interface, no new users are expected? Or is gcc smart, not 
> complaining when used as static initializer, as it would always evaluate to 
> (struct cpumask *)(bitmap)?

Yes, it seems to be.  AFAICT though, using a function in an initializer is not
valid C.

> Can the sizeof constification be removed?

Possibly, but it makes me nervous to rely on it.

Thanks,
Rusty.


> 
> Thanks
> Nikanth
> 
