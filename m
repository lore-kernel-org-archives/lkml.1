Return-Path: <linux-kernel-owner+w=401wt.eu-S1161020AbXCVK7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbXCVK7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXCVK7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:59:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37855 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161020AbXCVK7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:59:07 -0400
Date: Thu, 22 Mar 2007 11:59:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: g3vbv@blueyonder.co.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Message-ID: <20070322105908.GS752@stusta.de>
References: <45E59D64.3070202@blueyonder.co.uk> <200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org> <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070321184258.758a5a29.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 06:42:58PM -0700, Randy Dunlap wrote:
> On Thu, 22 Mar 2007 01:32:36 +0000 Sid Boyce wrote:
> 
> >...
> There's not a lot of docs out there.
> 
> The man-page:  http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
> 
> Linus's email doc:
> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
> 
> I worked on something over last weekend, but it doesn't really add
> much to the references above.
>...


FWIW:
My standard instructions for users who are asked to bisect are [1]:


<--  snip  -->

# install git and cogito on your computer

# clone Linus' tree:
cg-clone \ 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# start bisecting:
cd linux-2.6
git bisect start
git bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
git bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356

# start round
cp /path/to/.config .
make oldconfig
make
# install kernel, check whether it's good or bad, then:
git bisect [bad|good]
# start next round


After at about 8 reboots, you'll have found the guilty commit
("...  is first bad commit").


More information on git bisecting:
  man git-bisect

<--  snip  -->


> ~Randy

cu
Adrian

[1] the start and end commits and the number of reboots are variable,
    but the rest of the text is generic

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

