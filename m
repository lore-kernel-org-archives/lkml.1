Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZJRVrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZJRVrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 17:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZJRVrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 17:47:00 -0400
Received: from kroah.org ([198.145.64.141]:59336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZJRVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 17:46:59 -0400
Date: Sun, 18 Oct 2009 14:47:04 -0700
From: Greg KH <greg@kroah.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: carmelo73@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Fast LKM symbol resolution with SysV ELH hash table
Message-ID: <20091018214704.GA26592@kroah.com>
References: <4ADACD3A.9020803@gmail.com> <9b2b86520910180544g94ecc8fuf0d7849e18cd8937@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520910180544g94ecc8fuf0d7849e18cd8937@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 01:44:04PM +0100, Alan Jenkins wrote:
> Hypothetically: imagine we both finish our work and testing on the
> same machine shows hash tables saving 100% and bsearch saving 90%.  In
> absolute terms, hash tables might have an advantage of 0.03s on my
> system (where bsearch saved 0.3s), and a total advantage of 0.015s for
> the modules you tested (where hash tables saved ~0.15s).
> 
> Would you accept bsearch in this case?  Or would you feel that the
> performance of hash tables outweighed the extra memory requirements?

The performance difference in "raw" time speed might be much different
on embedded platforms with slower processors, so it might be worth the
tiny complexity to get that much noticed speed.

> (This leaves the question of why you need to load 0.015s worth of
> always-needed in-tree kernel code as modules.  For those who haven't
> read the slides, the  reasoning is that built-in code would take
> _longer_ to load.  The boot-loader is often slower at IO, and it
> doesn't allow other initialization to occur in parallel).

Distros are forced to build almost everything as modules.  I've played
with building some modules into the kernel directly (see the openSUSE
moblin kernels for examples of that), but when you have to suport a much
larger range of hardware types and features that some users use and
others don't, and the ability to override specific drivers by others due
to manufacturer requests for specific updates, the need to keep things
as modules is the only way to solve the problem.

So I'm glad to see this speedup happen, very nice work everyone.

thanks,

greg k-h
