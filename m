Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbZDPUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbZDPUNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZDPUN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:13:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZDPUNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:13:24 -0400
Date: Thu, 16 Apr 2009 22:12:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add "how to write a good patch summary"
	to SubmittingPatches
Message-ID: <20090416201255.GA21608@elte.hu>
References: <1239882285-4994-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239882285-4994-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Ts'o <tytso@mit.edu> wrote:

> Unfortunately many patch submissions are arriving with painfully 
> poor patch descriptions.  As a result of the discussion on LKML:
> 
>       http://lkml.org/lkml/2009/4/15/296
> 
> explain how to submit a better patch description, in the (perhaps 
> vain) hope that maintainers won't end up having to rewrite the git 
> commit logs as often as they do today.

> +Bear in mind that the "summary phrase" of your email becomes a
> +globally-unique identifier for that patch.  It propagates all the way
> +into the git changelog.  The "summary phrase" may later be used in
> +developer discussions which refer to the patch.  People will want to
> +google for the "summary phrase" to read discussion regarding that
> +patch.  It will also be the only thing that people may quickly see
> +when, two or three months later, they are going through perhaps
> +thousands of patches using tools such as "gitk" or "git log
> +--oneline".
> +
> +For these reasons, the "summary" must be no more than 70-75
> +characters, and it must describe both what the patch changes, as well
> +as why the patch might be necessary.  It is challenging to be both
> +succinct and descriptive, but that is what a well-written summary
> +should do.

I like that principle in theory, i really do.

The problem is, as so often, with practice.

Please allow me to argue with your own ext4 commit logs created in 
the past month. You brought up your commit logs as an example to 
follow in the other thread. I _do_ consider the ext4 commit logs a 
very good example and they are all cleanly done - kudos for that.

But to argue my case i'm kind of between a rock and a hard place: i 
can really only argue via showing how your own logs could be 
improved via impact lines - but then i risk making you defensive 
about them! I dont have high hopes to be able to convince you via 
this path, but i respect you a lot so please allow me this single 
attempt.

So ... please dont take any of this as criticism - hindsight is 
always easy - your commit logs are totally fine and well above 
average quality. I'm just trying to highlight in the examples below 
why the patch summary (patch title) approach often does not work in 
practice, and why people started adding tag-alike triaging 
information to commits.

I took the top 18 ext4 commits starting at v2.6.30-rc2-167-gcd97824. 
I picked the first 18 blindly by using:

   git log --no-merges --since=one-month-ago v2.6.30-rc2-167-gcd97824 fs/ext4/

Find below a detalied per commit log discussion with special 
emphasis on 'triaging / impact' information. I'll also list 
summaries further below about conclusions based on these commits, as 
i see them. ( When i wrote this sentence i have not read the commit 
logs yet - so it's a completely blind excercise on my part. I have 
to admit that i'm pretty sure about the rough outcome though, so i 
dont take a big gamble in saying this before seeing it. )

I chose a large enough set to be able to see some long-term 
patterns. It is much more work to analyze for me, but i think you'd 
dismiss just a few examples as outliers. (or worse, maybe even as 
some deliberate attempt on my part to pick up the worst commits to 
make a false point!!)

Commit #1:

| commit 226e7dabf5534722944adefbad01970bd38bb7ae
| Author: Nikanth Karthikesan <knikanth@suse.de>
| Date:   Wed Apr 15 10:36:16 2009 +0530
| 
|     ext4: Remove code handling bio_alloc failure with __GFP_WAIT
|     
|     Remove code handling bio_alloc failure with __GFP_WAIT.
|     GFP_NOIO implies __GFP_WAIT.
|     
|     Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
|     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

This might sound like a small detail, but as distro or -stable 
maintainers often scour through filesystem (and architecture) 
commits in search for bugfixes that got accidentally not tagged with 
Cc: stable tags. Seeing something in the shortlog that has this 
title:

      ext4: Remove code handling bio_alloc failure with __GFP_WAIT

potentially gives an incorrect first impression that this might be 
about some memory-pressure allocation failure fix. It is not 
necessarily clear to everyone from the summary alone that this is a 
pure cleanup.

Adding the impact-line makes this clear, as long as a good 
convention is followed in creating them. So this is how the commit 
would have looked like with structured impact information embedded:

| commit 226e7dabf5534722944adefbad01970bd38bb7ae
| Author: Nikanth Karthikesan <knikanth@suse.de>
| Date:   Wed Apr 15 10:36:16 2009 +0530
| 
|     ext4: Remove code handling bio_alloc failure with __GFP_WAIT
|     
|     Remove code handling bio_alloc failure with __GFP_WAIT.
|     GFP_NOIO implies __GFP_WAIT.
|     
|     [ Impact: cleanup ]
|
|     Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
|     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Look that it's obvious at a glance now, that the commit is not 
interesting to a distro kernel or to -stable. It is also probably 
not interesting to anyone searching for a bug.

When having to scan through hundreds, often thousands of new 
commits, it becomes very, very handy if there are easy visual
clues embedded in the commit that describe the nature of the
commit. These can be parsed by poor overworked commit triagers
even without having to understand _each_ commit - and this
really helps in terms of triaging efficiency.


Commit #2:

| commit 0f2ddca66d70c8ccba7486cf2d79c6b60e777abd
| Author: From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Tue Apr 7 14:07:47 2009 -0400
| 
|     ext4: check block device size on mount
|     
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


To an outsider, this commit is not specific enough at a glance. It 
does not tell us anything what motivated this change, what it fixes 
and how the fix will affect users. Looking into the patch itself 
exposes the real details:

+       /* check blocks count against device size */
+       blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
+       if (blocks_count && ext4_blocks_count(es) > blocks_count) {
+               printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu "
+                      "exceeds size of device (%llu blocks)\n",
+                      ext4_blocks_count(es), blocks_count);
+               goto failed_mount;
+       }
+

So this is about not mounting certain corrupted filesystems that 
have an inconsistent block size settings. So this impact line could 
have been added:

| commit 0f2ddca66d70c8ccba7486cf2d79c6b60e777abd
| Author: From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Tue Apr 7 14:07:47 2009 -0400
| 
|     ext4: check block device size on mount
|
|     [ Impact: fix crash when mounting a corrupted filesystem ]
|     
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Note, i am actually guessing what the real bug symptom was here - 
it might have been silent data corruption, not a kernel crash. Or 
we might have mounted it silently and it worked just fine - in 
which case i'd have added:

     [ Impact: detect corrupted filesystem sooner ]

There is no bugzilla information, no description about who reported 
it and there's no link to any lkml discussion either.

Note that depending on what the impact line is, the distro 
maintainer has different options for action. If the commit says 
'prevent crash', he might issue an urgent erratum. If the commit 
says 'fix inconsistency' he might not bother about fast-pathing it 
at all.

Nothing in the commit log actually gave us this kind of information.


Commit #3:

| commit e44543b83bf4ab84dc6bd5b88158c78b1ed1c208
| Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Sat Apr 4 23:30:44 2009 -0400
| 
|     ext4: Fix off-by-one-error in ext4_valid_extent_idx()
|     
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Same deal as with Commit #2 - there's no impact information at all. 
One can only guess about the impact. It's from the same author as 
Commit #2 so i suspect some concerted effort was made to inject 
random disk images into ext4 and observe how it behaves.

And the patch itself wasnt enough to tell me the full story - i had 
to use git grep and had to look around in the source to find the 
impact:

        if (!ext4_valid_extent_entries(inode, eh, depth)) {
                error_msg = "invalid extent entries";
                goto corrupted;
        }

So it's again about finding data corruption patterns sooner.

This kind of information is non-trivial to recover (especially to 
someone not versed in the details of your subsystem) - so an impact 
line would have been very helpful to the overworked commit triager:

| commit e44543b83bf4ab84dc6bd5b88158c78b1ed1c208
| Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Sat Apr 4 23:30:44 2009 -0400
| 
|     ext4: Fix off-by-one-error in ext4_valid_extent_idx()
|     
|     [ Impact: detect corrupted filesystem sooner ]
|
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Commit #4:

| commit f73953c0656f2db9073c585c4df2884a8ecd101e
| Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Tue Apr 7 18:46:47 2009 -0400
| 
|     ext4: Fix big-endian problem in __ext4_check_blockref()
|     
|     Commit fe2c8191 introduced a regression on big-endian system, because
|     the checks to make sure block references in non-extent inodes are
|     valid failed to use le32_to_cpu().
|     
|     Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
|     Cc: stable@kernel.org

Here the commit log is a lot more specific - but does not give us 
any information about what the observed problem was.

Did the filesystem not mount? Did it get corrupted? Depending on the 
answers, a distro maintainer might fast-path a fix out of line, or a 
developer / bisector might dismiss or include a commit in the set of 
suspicious-looking changes that might be relevant to a bug pattern 
he is seeing.

Googling for the summary line gives us the impact: this bug crashed 
Thiemo's box. So it would have been really handy to include the 
impact in the commit log (it was easily available when the commit 
was created):

| commit f73953c0656f2db9073c585c4df2884a8ecd101e
| Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Tue Apr 7 18:46:47 2009 -0400
| 
|     ext4: Fix big-endian problem in __ext4_check_blockref()
|     
|     Commit fe2c8191 introduced a regression on big-endian system, because
|     the checks to make sure block references in non-extent inodes are
|     valid failed to use le32_to_cpu().
|
|     [ Impact: fix crash-on-mount on big-endian systems ]
|     
|     Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
|     Cc: stable@kernel.org

Note the -stable tag. The stable team would certainly like to know 
the severity of the problem: if they are just 24 hours away from the 
next scheduled release, they might (or might not) include such a 
fix, depending on severity.

And not having to go in an interpret the commit fully (and just 
being able to trust _your tag_) speeds up triaging immensely.


Commit #5:

| commit c2ec175c39f62949438354f603f4aa170846aabb
| Author: Nick Piggin <npiggin@suse.de>
| Date:   Tue Mar 31 15:23:21 2009 -0700
| 
|     mm: page_mkwrite change prototype to match fault
|     
|     Change the page_mkwrite prototype to take a struct vm_fault, and return
|     VM_FAULT_xxx flags.  There should be no functional change.
|     
|     This makes it possible to return much more detailed error information to
|     the VM (and also can provide more information eg.  virtual_address to the
|     driver, which might be important in some special cases).
|     
|     This is required for a subsequent fix.  And will also make it easier to
|     merge page_mkwrite() with fault() in future.
|     
|     Signed-off-by: Nick Piggin <npiggin@suse.de>
|     Cc: Chris Mason <chris.mason@oracle.com>
|     Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
|     Cc: Miklos Szeredi <miklos@szeredi.hu>
|     Cc: Steven Whitehouse <swhiteho@redhat.com>
|     Cc: Mark Fasheh <mfasheh@suse.com>
|     Cc: Joel Becker <joel.becker@oracle.com>
|     Cc: Artem Bityutskiy <dedekind@infradead.org>
|     Cc: Felix Blyakher <felixb@sgi.com>
|     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
|     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Ok, this is a drive-by commit from -mm which was not Cc:-ed to you 
and which was not acked by you. The impact is trivial, and this is 
apparent only from the third line of the commit (i.e. the 
information is invisible to most tools). But reading the commit 
clearly establishes that this is a cleanup / preparation for future 
change.

This impact line might have helped preserve that information in a 
structured way:

|     [ Impact: cleanup, refactor call signature ]

As it makes it obvious to any bisector that this commit is really 
was not expected to cause side effects at the time when it was 
created. (it still can break things of curse - but mapping _intent_ 
is still very useful.)


Commit #6:

| commit ce3b0f8d5c2203301fc87f3aaaed73e5819e2a48
| Author: Al Viro <viro@zeniv.linux.org.uk>
| Date:   Sun Mar 29 19:08:22 2009 -0400
| 
|     New helper - current_umask()
|     
|     current->fs->umask is what most of fs_struct users are doing.
|     Put that into a helper function.
|     
|     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

The patch is visibly trivial, but the style of the commit departs 
from other ext4 commit styles so it's not necessarily obvious at a 
glance in a shortlog.

Injecting impact via a tree-wide convention could be done here:

| commit ce3b0f8d5c2203301fc87f3aaaed73e5819e2a48
| Author: Al Viro <viro@zeniv.linux.org.uk>
| Date:   Sun Mar 29 19:08:22 2009 -0400
| 
|     New helper - current_umask()
|     
|     current->fs->umask is what most of fs_struct users are doing.
|     Put that into a helper function.
|
|     [ Impact: cleanup ]
|     
|     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

This would have made it obvious at a glance - without getting used 
to and parsing the different commit style - that this commit is pure 
refactoring that was not expected to have have any side-effects at 
the time of its creation.

It is a _lot_ easier to establish a tree-wide convention for a 
single (and very important) tag line, that it would be to get every 
contributor and every maintainer to create precisely consistent 
summary lines.


Commit #7:

| commit 692105b8ac5bcd75dc65f6a8f10bdbd0f0f34dcf
| Author: Matt LaPlante <kernel1@cyberdogtech.com>
| Date:   Mon Jan 26 11:12:25 2009 +0100
| 
|     trivial: fix typos/grammar errors in Kconfig texts
|     
|     Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
|     Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
|     Signed-off-by: Jiri Kosina <jkosina@suse.cz>

This is clearly a trivial patch from the title and context - i didnt 
need to look at the patch to determine that. There is one small but 
nonzero problem with trivial patches though:

 - each subsystem has a different threshold for what it calls 
   'trivial' (for example in the x86 tree we only call 
   something trivial if it provably does not change the kernel 
   image.)

 - there's many conflicting tags to mark 'trivial' patches. Nick did 
   it differently at Commit #5. Al did it yet another way at Commit 
   #6. Here again it was done differently, from another tree.

A tree-wide convention tag:

|    [ Impact: trivial, no code changed ]

could standardize all this, and it could categorize pure 
documentation, comment, variable-rename kindof truly trivial patches 
in a uniform way.


Commit #8:

| commit 06705bff9114531a997a7d0c2520bea0f2927410
| Author: Theodore Ts'o <tytso@mit.edu>
| Date:   Sat Mar 28 10:59:57 2009 -0400
| 
|     ext4: Regularize mount options
|     
|     Add support for using the mount options "barrier" and "nobarrier", and
|     "auto_da_alloc" and "noauto_da_alloc", which is more consistent than
|     "barrier=<0|1>" or "auto_da_alloc=<0|1>".  Most other ext3/ext4 mount
|     options use the foo/nofoo naming convention.  We allow the old forms
|     of these mount options for backwards compatibility.
|     
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This is the first non-trivial commit in the list that tells us the 
true impact of the change in a prominent place: in the second line 
of the commit.

( A very mild criticism would be that summary line is meaningless. 
  What does 'regularize' mean - it tells us nothing straight away. I 
  have to look into the text to find out that it adds four new mount 
  option aliases. )

This standard impact line could have been added:

| commit 06705bff9114531a997a7d0c2520bea0f2927410
| Author: Theodore Ts'o <tytso@mit.edu>
| Date:   Sat Mar 28 10:59:57 2009 -0400
| 
|     ext4: Regularize mount options
|     
|     Add support for using the mount options "barrier" and "nobarrier", and
|     "auto_da_alloc" and "noauto_da_alloc", which is more consistent than
|     "barrier=<0|1>" or "auto_da_alloc=<0|1>".  Most other ext3/ext4 mount
|     options use the foo/nofoo naming convention.  We allow the old forms
|     of these mount options for backwards compatibility.
|
|     [ Impact: add 4 new mount option aliases ]
|     
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

To express this kind of information for sure. Once you commit 
yourself to adding an impact line, you generally add a meaningful 
one - especially if you care about commit quality.


Commit #9:

| commit e7c9e3e99adf6c49c5d593a51375916acc039d1e
| Author: Theodore Ts'o <tytso@mit.edu>
| Date:   Fri Mar 27 19:43:21 2009 -0400
| 
|     ext4: fix locking typo in mballoc which could cause soft lockup hangs
|     
|     Smatch (http://repo.or.cz/w/smatch.git/) complains about the locking in
|     ext4_mb_add_n_trim() from fs/ext4/mballoc.c
|     
|       4438          list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
|       4439                                                  pa_inode_list) {
|       4440                  spin_lock(&tmp_pa->pa_lock);
|       4441                  if (tmp_pa->pa_deleted) {
|       4442                          spin_unlock(&pa->pa_lock);
|       4443                          continue;
|       4444                  }
|     
|     Brown paper bag time...
|     
|     Reported-by: Dan Carpenter <error27@gmail.com>
|     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
|     Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
|     Cc: stable@kernel.org

The first non-trivial commit that tells us the true impact of the 
patch in the patch summary line!

Still, this standard line:

|     
|     [ Impact: fix possible soft hang ]
|

Could have alerted distros to issue an emergency kernel package 
update straight away, if they do nothing else but look at the impact 
lines. [ Or they could have delayed it, noticing the 'possible' 
qualifier and seeing that the bug was found via static analysis. ]


Commit #10:

| commit a7b19448ddbdc34b2b8fedc048ba154ca798667b
| Author: Dan Carpenter <error27@gmail.com>
| Date:   Fri Mar 27 19:42:54 2009 -0400
| 
|     ext4: fix typo which causes a memory leak on error path
|     
|     This was found by smatch (http://repo.or.cz/w/smatch.git/)
|     
|     Signed-off-by: Dan Carpenter <error27@gmail.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
|     Cc: stable@kernel.org

This too is a good summary line. But there's an important element 
missing: likelyhood of the problem. The following impact line might 
have helped:

| commit a7b19448ddbdc34b2b8fedc048ba154ca798667b
| Author: Dan Carpenter <error27@gmail.com>
| Date:   Fri Mar 27 19:42:54 2009 -0400
| 
|     ext4: fix typo which causes a memory leak on error path
|     
|     This was found by smatch (http://repo.or.cz/w/smatch.git/)
|     
|     [ Impact: fix possible small memory leak under high memory pressure ]
|
|     Signed-off-by: Dan Carpenter <error27@gmail.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
|     Cc: stable@kernel.org

Notice the many qualifiers that the impact line has. It signals that 
to hit the bug, some considerable memory pressure has to exist to 
make a kmalloc() fail - which kmalloc itself is in a rare path. And 
even in that case, the leak is very small and probably not 
noticeable on today's typical multi-gigabyte systems.

So a distro maintainer would probably have skipped this patch seeing 
a correct impact line - but without the impact line he has to repeat 
this analysis.


Commit #11:

| commit cc0fb9ad7dbc5a149f4957a0dd6d65881d3d385b
| Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
| Date:   Fri Mar 27 17:16:58 2009 -0400
| 
|     ext4: Rename pa_linear to pa_type
|     
|     Impact: code cleanup
|     
|     This patch rename pa_linear to pa_type and add MB_INODE_PA
|     and MB_GROUP_PA to indicate inode and group prealloc space.
|     
|     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
|     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Ha, a commit with an impact line, perfect! :-)

"Impact: cleanup" told me straight away that there's nothing 
sophisticated to see here. (unless i've excluded more likely sources 
of problems and i'm out here to find a possible bug in a 
marked-harmless patch.)


Commit #12:

| commit fe2c8191faa29d7a09f4962198f6dfab973ceec4
| Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Tue Mar 31 08:36:10 2009 -0400
| 
|     ext4: add checks of block references for non-extent inodes
|     
|     Check block references in the inode and indorect blocks for non-extent
|     inodes to make sure they are valid, and flag an error if they are
|     invalid.
|     
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

A pretty good one too - albeit it does not tell us under what 
circumstances (and with what likelyhood) this bug can trigger.

( btw., there's a s/indorect/indirect typo in the changelog ;)

Looking at the patch suggests this impact line addition:

| commit fe2c8191faa29d7a09f4962198f6dfab973ceec4
| Author: Thiemo Nagel <thiemo.nagel@ph.tum.de>
| Date:   Tue Mar 31 08:36:10 2009 -0400
| 
|     ext4: add checks of block references for non-extent inodes
|     
|     Check block references in the inode and indorect blocks for non-extent
|     inodes to make sure they are valid, and flag an error if they are
|     invalid.
|
|     [ Impact: extend filesystem corruption error checks ]
|     
|     Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


Commit #13:

| commit 563bdd61fe4dbd6b58cf7eb06f8d8f14479ae1dc
| Author: Theodore Ts'o <tytso@mit.edu>
| Date:   Thu Mar 26 00:06:19 2009 -0400
| 
|     ext4: Check for an valid i_mode when reading the inode from disk
|     
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This too could get a:

|     [ Impact: extend filesystem corruption error checks ]

but the summary line is already pretty specific about that.


Commit #14:

| commit a269eb18294d35874c53311acc2cd0b5ef477ce5
| Author: Jan Kara <jack@suse.cz>
| Date:   Mon Jan 26 17:04:39 2009 +0100
| 
|     ext4: Use lowercase names of quota functions
|     
|     Use lowercase names of quota functions instead of old uppercase ones.
|     
|     Signed-off-by: Jan Kara <jack@suse.cz>
|     Acked-by: Mingming Cao <cmm@us.ibm.com>
|     CC: linux-ext4@vger.kernel.org

The commit log could be improved a tiny bit: it is not mentioned 
here that the old uppercase functions were exactly the same as the 
lowercase functions.

That fact was obvious to _you_, because you do filesystems - but to 
anyone external (to the general reader of the commit log) - that is 
not obvious. I had to go back in history to recover this fact for 
example.

Adding an impact line:

| commit a269eb18294d35874c53311acc2cd0b5ef477ce5
| Author: Jan Kara <jack@suse.cz>
| Date:   Mon Jan 26 17:04:39 2009 +0100
| 
|     ext4: Use lowercase names of quota functions
|     
|     Use lowercase names of quota functions instead of old uppercase ones.
|
|     [ Impact: cleanup ]
|     
|     Signed-off-by: Jan Kara <jack@suse.cz>
|     Acked-by: Mingming Cao <cmm@us.ibm.com>
|     CC: linux-ext4@vger.kernel.org

Codifies this fact in a more obvious way.


Commit #15:

| commit 60e58e0f30e723464c2a7d34b71b8675566c572d
| Author: Mingming Cao <cmm@us.ibm.com>
| Date:   Thu Jan 22 18:13:05 2009 +0100
| 
|     ext4: quota reservation for delayed allocation
|     
|     Uses quota reservation/claim/release to handle quota properly for delayed
|     allocation in the three steps: 1) quotas are reserved when data being copied
|     to cache when block allocation is defered 2) when new blocks are allocated.
|     reserved quotas are converted to the real allocated quota, 2) over-booked
|     quotas for metadata blocks are released back.
|     
|     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
|     Acked-by: "Theodore Ts'o" <tytso@mit.edu>
|     Signed-off-by: Jan Kara <jack@suse.cz>

Firstly, the summary line is missing a verb. (probably "add" or 
"use") So the shortlog is not very readable.

Secondly, the descripton does not clearly describe the practical 
impact. I had to look into the patch itself to recover the fact that 
this (probably!) fixes a bug in ext4's delayed allocation code - it 
was not fully coherent with quota systems before.

This is one of those feature patches which can break stuff and whose 
accurate tagging can be particularly helpful during bug triage:

| commit 60e58e0f30e723464c2a7d34b71b8675566c572d
| Author: Mingming Cao <cmm@us.ibm.com>
| Date:   Thu Jan 22 18:13:05 2009 +0100
| 
|     ext4: quota reservation for delayed allocation
|     
|     Uses quota reservation/claim/release to handle quota properly for delayed
|     allocation in the three steps: 1) quotas are reserved when data being copied
|     to cache when block allocation is defered 2) when new blocks are allocated.
|     reserved quotas are converted to the real allocated quota, 2) over-booked
|     quotas for metadata blocks are released back.
|     
|     [ Impact: implement precise quota handling of delayed allocations ]
|
|     Signed-off-by: Mingming Cao <cmm@us.ibm.com>
|     Acked-by: "Theodore Ts'o" <tytso@mit.edu>
|     Signed-off-by: Jan Kara <jack@suse.cz>

The impact line tells us what matters to users: that this commit 
improves ext4, that the improvement probably only matters in 
borderline situations when users are close to the max of their 
quota.

Such distinctions can help in bug triaging, again.


Commit #16:

| commit edf7245362f7b8b8c76c4a6cad3604bf80884848
| Author: Jan Kara <jack@suse.cz>
| Date:   Mon Jan 12 19:05:26 2009 +0100
| 
|     ext4: Remove unnecessary quota functions
|     
|     ext4_dquot_initialize() and ext4_dquot_drop() is no longer
|     needed because of modified quota locking.
|     
|     Signed-off-by: Jan Kara <jack@suse.cz>

This looks like a cleanup, but might have side-effects. A good 
impact line here helps alert the reader/triager to this fact:

| commit edf7245362f7b8b8c76c4a6cad3604bf80884848
| Author: Jan Kara <jack@suse.cz>
| Date:   Mon Jan 12 19:05:26 2009 +0100
| 
|     ext4: Remove unnecessary quota functions
|     
|     ext4_dquot_initialize() and ext4_dquot_drop() is no longer
|     needed because of modified quota locking.
|
|     [ Impact: simplify/standardize quota init/deinit ]
|     
|     Signed-off-by: Jan Kara <jack@suse.cz>

As we are doing the same thing in a simpler way - which ought to 
work with the new quota code but is not guaranteed to be 
trouble-free. So it would be wrong to tag this as "Impact: cleanup".

The summary line is also misleading a tiny bit: an inattentive 
reader might assume that all that happens here is we drop some dead 
code. But that's not true: we switch an old-style ext4 quota 
init/deinit wrapper function to a modern method of directly using 
the quota layer.

Again, the impact line helps force full impact disclosure here.


Commit #17:

| commit d33a1976fbee1ee321d6f014333d8f03a39d526c
| Author: Eric Sandeen <sandeen@redhat.com>
| Date:   Mon Mar 16 23:25:40 2009 -0400
| 
|     ext4: fix bb_prealloc_list corruption due to wrong group locking
|     
|     This is for Red Hat bug 490026: EXT4 panic, list corruption in
|     ext4_mb_new_inode_pa
|     
|     ext4_lock_group(sb, group) is supposed to protect this list for
|     each group, and a common code flow to remove an album is like
|     this:
|     
|         ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
|         ext4_lock_group(sb, grp);
|         list_del(&pa->pa_group_list);
|         ext4_unlock_group(sb, grp);
|     
|     so it's critical that we get the right group number back for
|     this prealloc context, to lock the right group (the one
|     associated with this pa) and prevent concurrent list manipulation.
|     
|     however, ext4_mb_put_pa() passes in (pa->pa_pstart - 1) with a
|     comment, "-1 is to protect from crossing allocation group".
|     
|     This makes sense for the group_pa, where pa_pstart is advanced
|     by the length which has been used (in ext4_mb_release_context()),
|     and when the entire length has been used, pa_pstart has been
|     advanced to the first block of the next group.
|     
|     However, for inode_pa, pa_pstart is never advanced; it's just
|     set once to the first block in the group and not moved after
|     that.  So in this case, if we subtract one in ext4_mb_put_pa(),
|     we are actually locking the *previous* group, and opening the
|     race with the other threads which do not subtract off the extra
|     block.
|     
|     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

A really good commit log - the first "100% perfect one" i'd say.

( okay, there's always small details to nitpick about: 
  capitalization and punctuation of sentences is not consistent :-)

For the sake of the overworked reader/triager, a uniform impact line 
helps summarize what the commit summarizes in its second and third 
line already, in a standard form:

|     [ Impact: fix kernel panic triggered during stress-tests ]


Commit #18:

| commit afd4672dc7610b7feef5190168aa917cc2e417e4
| Author: Theodore Ts'o <tytso@mit.edu>
| Date:   Mon Mar 16 23:12:23 2009 -0400
| 
|     ext4: Add auto_da_alloc mount option
|     
|     Add a mount option which allows the user to disable automatic
|     allocation of blocks whose allocation by delayed allocation when the
|     file was originally truncated or when the file is renamed over an
|     existing file.  This feature is intended to save users from the
|     effects of naive application writers, but it reduces the effectiveness
|     of the delayed allocation code.  This mount option disables this
|     safety feature, which may be desirable for prodcutions systems where
|     the risk of unclean shutdowns or unexpected system crashes is low.
|     
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

This too is a perfect commit, with impact information in the summary 
line. Given that many other commits are not nearly this perfect, a 
standard impact line does inject value:

| commit afd4672dc7610b7feef5190168aa917cc2e417e4
| Author: Theodore Ts'o <tytso@mit.edu>
| Date:   Mon Mar 16 23:12:23 2009 -0400
| 
|     ext4: Add auto_da_alloc mount option
|     
|     Add a mount option which allows the user to disable automatic
|     allocation of blocks whose allocation by delayed allocation when the
|     file was originally truncated or when the file is renamed over an
|     existing file.  This feature is intended to save users from the
|     effects of naive application writers, but it reduces the effectiveness
|     of the delayed allocation code.  This mount option disables this
|     safety feature, which may be desirable for prodcutions systems where
|     the risk of unclean shutdowns or unexpected system crashes is low.
|
|     [ Impact: add new mount option ]
|     
|     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

A small detail: note how this is somewhat different than the impact 
line we saw at Commit 8:

|     [ Impact: add 4 new mount option aliases ]

And look how the two _summary_ lines dont line up as well as the 
impact lines:

|     ext4: Regularize mount options
|     ext4: Add auto_da_alloc mount option

the first one has to be checked for one to see the impact. The 
second one is fine.


Ok, let me sum up all the 18 commits at a glance, via their summary 
lines:

226e7da: ext4: Remove code handling bio_alloc failure with __GFP_WAIT
0f2ddca: ext4: check block device size on mount
e44543b: ext4: Fix off-by-one-error in ext4_valid_extent_idx()
f73953c: ext4: Fix big-endian problem in __ext4_check_blockref()
c2ec175: mm: page_mkwrite change prototype to match fault
ce3b0f8: New helper - current_umask()
692105b: trivial: fix typos/grammar errors in Kconfig texts
06705bf: ext4: Regularize mount options
e7c9e3e: ext4: fix locking typo in mballoc which could cause soft lockup hangs
a7b1944: ext4: fix typo which causes a memory leak on error path
cc0fb9a: ext4: Rename pa_linear to pa_type
fe2c819: ext4: add checks of block references for non-extent inodes
563bdd6: ext4: Check for an valid i_mode when reading the inode from disk
a269eb1: ext4: Use lowercase names of quota functions
60e58e0: ext4: quota reservation for delayed allocation
edf7245: ext4: Remove unnecessary quota functions
d33a197: ext4: fix bb_prealloc_list corruption due to wrong group locking
afd4672: ext4: Add auto_da_alloc mount option

Only less than half of the 18 summary lines tell us the true impact 
- and even those do it very inconsistent manner. There's frequent 
variations in style, formulation, capitalization and often the 
impact is not mentioned at all in the summary.

See how hard it is to judge impact at a glance?

Now lets see the 18 impact lines grepped out of the extended logs:

|     Impact: cleanup
|     Impact: fix crash when mounting a corrupted filesystem
|     Impact: detect corrupted filesystem sooner
|     Impact: fix crash-on-mount on big-endian systems
|     Impact: cleanup, refactor call signature
|     Impact: cleanup
|     Impact: trivial, no code changed
|     Impact: add 4 new mount option aliases
|     Impact: fix possible soft hang
|     Impact: fix possible small memory leak under high memory pressure
|     Impact: code cleanup
|     Impact: extend filesystem corruption error checks
|     Impact: extend filesystem corruption error checks
|     Impact: cleanup
|     Impact: implement precise quota handling of delayed allocations
|     Impact: simplify/standardize quota init/deinit
|     Impact: fix kernel panic triggered during stress-tests
|     Impact: add new mount option

Look how a whole new world opens up! At a glance we can see the risk 
picture of all commits in this topic. The summary lines didnt come 
even _close_ to giving us this kind of oversight.

as a bug triager i can, within 1 minute, sort all the commits by 
risk:

Low risk cleanups:

|     Impact: cleanup
|     Impact: cleanup
|     Impact: cleanup
|     Impact: code cleanup
|     Impact: trivial, no code changed
|     Impact: cleanup, refactor call signature

Runtime crash fixes:

|     Impact: fix crash-on-mount on big-endian systems
|     Impact: fix possible soft hang
|     Impact: fix kernel panic triggered during stress-tests
|     Impact: fix possible small memory leak under high memory pressure

Robustness enhancements:

|     Impact: fix crash when mounting a corrupted filesystem
|     Impact: detect corrupted filesystem sooner
|     Impact: extend filesystem corruption error checks
|     Impact: extend filesystem corruption error checks

Low-risk features:

|     Impact: add 4 new mount option aliases
|     Impact: add new mount option
|     Impact: simplify/standardize quota init/deinit

High-risk features:

|     Impact: implement precise quota handling of delayed allocations

At a glance i was able to filter out the most risky commit out of 18 
commits to a critical filesystem:

  60e58e0: ext4: quota reservation for delayed allocation

and when seeing any regression in this code area i'd first check the 
"High-risk features" and then the "Runtime crash fixes" buckets - as 
those involve the most risky changes in general.

And that's just 18 commits. We have 10,000 commits in every kerenel 
cycle, and more than 1000 commits of that go via the trees hpa and 
me is maintaining. It's 2-3 orders of a magnitude difference.

I hope this small example helps explain why we are trying to work on 
injecting more order into the risk/impact picture. It is an 
important metric - perhaps the most important metric in improving 
the quality of the kernel.

It helps bug tracking, it helps maintenance, it helps stable kernel 
and distro kernel maintainers. Yes, a good summary line would help 
too - but the reality tells us that it does not. Not even for your 
top-of-the-line subsystem.

[ Plus all the other advantages i did not mention but mentioned at 
  great length in the other threads. ]

Thanks,

	Ingo
