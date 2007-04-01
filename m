Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXDAHdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXDAHdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 03:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXDAHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 03:33:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:46993 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXDAHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 03:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VuDg12YHR9UAeyNOC8w7QfNdA4zfqRIczdqAwVjqIwIKsqwhdJ/ifRU2AikmOZ4GvsWNIWwFyuknmVot2ebJSVjaH80wfJmoMcGPt76iggC5XgqrTGMp3UbkyWcJOXCxmStauLyTdKYI7L7WI8vcTE7VsCG64epAzXWiovCvBmc=
Message-ID: <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
Date: Sun, 1 Apr 2007 00:33:02 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
Cc: "Ingo Molnar" <mingo@elte.hu>, amanda-hackers@amanda.org,
       linux-kernel@vger.kernel.org, amanda-users@amanda.org
In-Reply-To: <200704010100.19016.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/07, Gene Heskett <gene.heskett@verizon.net> wrote:
> This effect I have isolated down to something in the 31 patches from
> 2.6.20.4 to 2.6.20.5-rc1, but I'm going to need additional guidance in
> setting up the bisect to find it.  If indeed its a kernel problem.

First, set up a *small* test case, for your own sanity as well as
ours. (Set up a new backup job that does just part of your home
directory, for example. No, even better, just one file.) Then verify
that the small test case also fails the same was that you noticed your
big one does between 2.6.20.3 and 2.6.20.4.

Then, download everything in http://madrabbit.org/~ray/2.6.20.4 . That
has all the patches that Greg has in git, but your git is ancient so
let's just use the patches, hmm? It also has a control file (called
'series') that lists the order they should be applied in. Save
everything to the root of your 2.6.20.3 source tree. It'll be messy,
but it'll make things easier.

Once you have that, then go and apply the first half of the patches. (As in:
   head -n 16 series | xargs -n 1 patch -p1
at the base of the tree.

Compile and install that kernel, run your test case to see if the
problem is there. If it *is*, cut it in half again (Revert those 16
patches by adding a -R to the patch command (at the very end), then
redo the above command with an 8 instead of a 16.) If the problem
isn't there, cut the range [16,31] in half, giving you a 24 for the
next trial. Then repeat. Make sense?

Ray
