Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYGHAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYGHAA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYGHAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:00:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37602 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYGHAAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:00:17 -0400
Subject: Re: [PATCH] [0/9] Use 64bit x86 machine check code for 32bit too
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48728C81.7080708@kernel.org>
References: <200807041120.678642023@firstfloor.org>
	 <48728A0E.7010802@kernel.org>  <48728C81.7080708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Jul 2008 17:00:15 -0700
Message-Id: <1215475215.6036.10.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 14:37 -0700, H. Peter Anvin wrote:
> H. Peter Anvin wrote:
> > Andi Kleen wrote:
> >> This patchkit uses the 64bit machine check code which is better in many
> >> ways on 32bit x86 too. This is also the basis for some future machine
> >> check work.
> > 
> > Hi Andi,
> > 
> > I tried applying your patch kit to -tip, but I'm getting build failures 
> > on i386; gcc-4.1.1-51.fc5.x86_64 with attached configuration.
> > 
> 
> FWIW, this is rooting the branch on top of current linus.  Applied on 
> top of tip/auto-x86-next or tip/master, the patch does not apply.
> 
> 	-hpa

The patches won't apply to -tip because Venki's patch has to be backed
out of mce_64.c and it looks like thread_info.h has been merged in the
mean time. 

I was able to apply the patches to 2.6.26-rc8 though, build it and boot
it. 
However it turns out the build warnings about 
"mce_64.c:822: warning: passing argument 2 of ‘strict_strtoull’ makes
integer from pointer without a cast"
are justified. It looks like strict_strtoull has the last two arguments
switched with respect to simple_strtoull. You get a NULL pointer
dereference as soon as you write to one of the machinecheck sysfs
control files.

Max


