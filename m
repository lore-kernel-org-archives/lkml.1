Return-Path: <linux-kernel-owner+w=401wt.eu-S1750840AbXA0P7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbXA0P7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 10:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXA0P7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 10:59:05 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39440 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbXA0P7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 10:59:04 -0500
Date: Sat, 27 Jan 2007 16:59:12 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: git/cogito/stgit interaction problem
Message-ID: <20070127155912.GJ6017@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I often run into the following annoying problem when working on the 
2.6.16 and trivial trees:

I want to change or delete the x-th commit from the top under the 
following prerequisites:
- the last x commits don't contain merges
- the last x commits aren't pushed anywhere else

The only tool I know that helps me doing this conveniently is stgit.


Testcase:

$ cg-push  #  everything is pushed in this testcase
$ vi Makefile
$ cg-commit 
Committed as 94b13e5b0f46ba38ee6fd8f47b418d8a18eded52
$ stg init
$ stg uncommit -n 1  #  uncommit x-1 commits
Uncommitting 1 patches... done
$ stg pop -a
Popping patch "asdf"... done
No patches applied
$ #  in real use cases, that's the point where I'm using 
$ #  cg-admin-uncommit (plus perhaps later cg-commit) on the x-th commit
$ stg push -a
Fast-forwarded patch "asdf"
Now at patch "asdf"
$ stg commit
Committing 1 patches... done
$ cg-admin-uncommit -t
Rewinding 94b13e5b0f46ba38ee6fd8f47b418d8a18eded52 (HEAD) -> 08ceda6f8c5d68108308cf01fc5c3ec35775baa9
$ cg-push  # should work (and report that the tree is unchanged in this testcase)
bunk@master.kernel.org's password: 
error: src refspec master matches more than one.
fatal: unexpected EOF
$ cat .git/refs/bases/master 
94b13e5b0f46ba38ee6fd8f47b418d8a18eded52
$ rm -r .git/refs/bases  #  workaround found using Google
$ cg-push  # works fine
bunk@master.kernel.org's password: 
Everything up-to-date
$ 


Versions:
git 1.4.4.4
cogito 0.18.2
stgit 0.11


Any hints on whom to blame for this?
Or if these tools aren't expected to work together in this way, what is 
the official way for getting the same functionality?


TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

