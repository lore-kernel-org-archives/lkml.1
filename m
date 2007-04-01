Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbXDAPmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbXDAPmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXDAPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:42:13 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:49399 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXDAPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:42:13 -0400
Date: Sun, 01 Apr 2007 11:41:52 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
To: linux-kernel@vger.kernel.org, ray-gmail@madrabbit.org
Cc: "Ingo Molnar" <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Message-id: <200704011141.53105.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <2c0942db0704010033r61f967c3y7d05e3ec0a9f6931@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2007, Ray Lee wrote:
>On 3/31/07, Gene Heskett <gene.heskett@verizon.net> wrote:
>> This effect I have isolated down to something in the 31 patches from
>> 2.6.20.4 to 2.6.20.5-rc1, but I'm going to need additional guidance in
>> setting up the bisect to find it.  If indeed its a kernel problem.
>
>First, set up a *small* test case, for your own sanity as well as
>ours. (Set up a new backup job that does just part of your home
>directory, for example. No, even better, just one file.) Then verify
>that the small test case also fails the same was that you noticed your
>big one does between 2.6.20.3 and 2.6.20.4.

That will require I setup a vtape someplace else on the system.
Later, I find the vtapes locations etc are hardcoded into the amanda 
executables, so I'm going to have to rebuild and reinstall amanda after 
copying my regular config driver to a backup version.  Not terribly 
difficult, but I will have to shut down the user amanda's crontab entry 
till we are done with the testing.  This is all part of amanda's security 
model.

Ok, got that done. All logs and such will be to a different location so as 
not to disturb the normal backup once it has been resumed.  The disklist 
has been stripped down to /home.  I guess its time to reboot and test 
run.  I'll reply to this message's thread with the results.

>Then, download everything in http://madrabbit.org/~ray/2.6.20.4 . That
>has all the patches that Greg has in git, but your git is ancient so
>let's just use the patches, hmm?

My git & quilt is now the latest from the FC6 repos.

>It also has a control file (called 
>'series') that lists the order they should be applied in. Save
>everything to the root of your 2.6.20.3 source tree. It'll be messy,
>but it'll make things easier.
>
>Once you have that, then go and apply the first half of the patches. (As
> in: head -n 16 series | xargs -n 1 patch -p1
>at the base of the tree.
>
>Compile and install that kernel, run your test case to see if the
>problem is there. If it *is*, cut it in half again (Revert those 16
>patches by adding a -R to the patch command (at the very end), then
>redo the above command with an 8 instead of a 16.) If the problem
>isn't there, cut the range [16,31] in half, giving you a 24 for the
>next trial. Then repeat. Make sense?
>
>Ray



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Beer -- it's not just for breakfast anymore.
