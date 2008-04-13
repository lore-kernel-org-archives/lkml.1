Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYDMUYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYDMUYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYDMUXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:23:54 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33414 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYDMUXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:23:54 -0400
Date: Sun, 13 Apr 2008 23:22:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, tilman@imap.cc
Subject: Re: 2.6.25-rc8: FTP transfer errors
Message-ID: <20080413202253.GF13920@cs181133002.pp.htv.fi>
References: <236089132@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <236089132@web.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 10:41:44AM +0200, devzero@web.de wrote:
> >Sure. It's not about bisection specifically, but about the time a
> >reporter is able to invest in addition to what went into the report
> >already. But bisection is is a good example, because it's the most
> >time-consuming of all the tasks routinely asked from bug reporters.
> 
> i think the problem with git-bisect is, that it just apears complicated and magic for an end-user. 
> this isn`t something a kernel-developer can explain to him in a sentence (i.e. how to use etc)
>...

When I ask a user to bisect, the standard boilerplate I give to the 
user is:

<--  snip  -->

# install git

# clone Linus' tree:
git clone \ 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# start bisecting:
cd linux-2.6
git bisect start
git bisect bad v2.6.21
git bisect good v2.6.20
cp /path/to/.config .

# start a round
make oldconfig
make
# install kernel, check whether it's good or bad, then:
git bisect [bad|good]
# start next round


After at about 10-15 reboots you'll have found the guilty commit
("...  is first bad commit").


More information on git bisecting:
  man git-bisect

<--  snip  -->

In my experience users are able to bisect with this boilerplate
(unless there are problems like e.g. other regressions hit 
during bisecting).

> regards
> roland
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

