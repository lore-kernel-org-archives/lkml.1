Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYAPMbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYAPMbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYAPMaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:30:55 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:27821 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752292AbYAPMay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:30:54 -0500
Date: Wed, 16 Jan 2008 13:30:52 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org
Subject: Re: mtime updates for mmapped files.
Message-ID: <20080116123052.GB2451@bitwizard.nl>
References: <20080116094640.GA2071@bitwizard.nl> <4df4ef0c0801160322j31645554oa6faec5cca64509d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df4ef0c0801160322j31645554oa6faec5cca64509d@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 02:22:49PM +0300, Anton Salikhmetov wrote:
> Unfortunately, this issue has not been fully fixed yet.
> 
> My last attempt (http://lkml.org/lkml/2008/1/15/202) to solve
> this problem has a couple of drawbacks:
> 
> 1) calling a possibly sleeping function from atomic context -
> I've already corrected this;
> 
> 2) there's a very special case with retouching the memory-mapped data
> after a call to msync() with MS_ASYNC.
 
> I'm still working on the latter case, but I guess that I have found
> a solution.
 
> If you badly need a quick fix, I can send my working unreleased
> patch to you.  I reckon that your particular problem will be fixed
> by this patch.  Let me know if you want that.

No need. Thanks for the offer. 

> However, if your application calls msync() with the MS_ASYNC flag,
> it's better to wait a little bit more - I'll release the next version
> of my solution
> shortly.

My application calls "exit" (*). My workaround was to type

	touch <destfile>

to get things to work. In my situation, I was worried about the more
general case, and not really about my personal situation.

I could integrate the "touch <destfile>" into my application, but I
think it is the OS's duty to do this for me. This would be the easiest
non-manual fix for me.

	Roger.

(*) So please check that: 
	- mmap file
	- change mmapped area
	- exit
also works (modifies the timestamp). 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
