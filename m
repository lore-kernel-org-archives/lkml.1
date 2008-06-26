Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYFZDgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYFZDgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 23:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYFZDfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 23:35:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18831 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYFZDfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 23:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pBOXoB8eqnjMc1IBCP2DOwhFXW6C/DqCtrl3du7GYPBnekHNJ6sI7Xa2Wtpxb4ZmLr
         LhOlXYJBLG5udElmNJK0j+2SmRUthiX298nAAx2MqwUNeQOuBkdauAfVNxD7XgrrZZ/3
         BO0ffry/IDTM1BLWDvBg1qY4Pm9atKv6cKzbk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [3/10 PATCH] inline wake_up_bit
Date: Thu, 26 Jun 2008 05:35:59 +0200
User-Agent: KMail/1.8.2
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
References: <200806251724.57689.vda.linux@googlemail.com> <200806252237.58046.vda.linux@googlemail.com> <20080625.172838.242554644.davem@davemloft.net>
In-Reply-To: <20080625.172838.242554644.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260535.59306.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 02:28, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Wed, 25 Jun 2008 22:37:58 +0200
> > > Sparc64 has register windows: it passes arguments in registers, but it 
> > > must allocate space for that registers. If the call stack is too deep (8 
> > > levels), the CPU runs out of registers and starts spilling the registers 
> > > of the function 8-levels-deep to the stack.
> > > 
> > > The stack usage could be reduced to 176 bytes with little work from gcc 
> > > developers and to 128 bytes with more work (ABI change). If you wanted to 
> > 
> > Wow, it's nearly x2 reduction.
> > 
> > ABI change in not a problem for kernel, since it is a "freestanding
> > application". Exactly like i386 switched to regparm, which is a different ABI.
> 
> Except that nobody has written this code and therefore being about to
> use this unimplemented compiler facility to get correctness is not
> tenable.

Inlining everything is even less tenable. Why architectures which do not
require 128+ bytes of stack for every function call should suffer?

I am all for fixing code where there are extra useless levels of calls,
but in this example I pointed out that patch adds inlines too liberally.
Do you agree that blowing up every wake_up_bit() into half a dozen
or more C lines is not what we want?
--
vda
