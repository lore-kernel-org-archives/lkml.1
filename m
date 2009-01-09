Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZAIU3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZAIU3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZAIU2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:28:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:15086 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZAIU2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AheTKO73ZWLDF+LIkTqE7bXsfOYPaCMEG6jhLvCkyaVb720xuOR6BdogHLeDvzr5Nd
         Wmob1hw/tMacxsZn/kA8zCta6WHtFEY6zC3rMmadfa6dSZNBcm4g8Y/zGHoLxsFrw/+9
         iICls11ikVJfQdixuZCatP74LhBvupHPuKY38=
Message-ID: <45a44e480901091228s59259c81tee1f7d4d4b19f49a@mail.gmail.com>
Date: Sat, 10 Jan 2009 04:28:51 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Oops in bluetooth on gumstix
Cc: "David Howells" <dhowells@redhat.com>, "James Morris" <jmorris@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I pulled mainline to play with on my gumstix and encountered the
following oops associated with bluetooth which was previously okay on
2.6.27. Here's the oops message:

gumstix-custom-basix login: bnep0 (): not using net_device_ops yet
Unable to handle kernel NULL pointer dereference at virtual address 00000150
pgd = c0004000
[00000150] *pgd=00000000
Internal error: Oops: f5 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.28gum-07487-gb7bc23a-dirty #3)
PC is at set_dumpable+0x30/0xbc
LR is at commit_creds+0x118/0x220
pc : [<c0086bd0>]    lr : [<c004f9c4>]    psr: 60000093
sp : c3b2def0  ip : c3b2df00  fp : c3b2defc
r10: c3b2c000  r9 : c3a0e200  r8 : 00000000
r7 : 00000000  r6 : c38ac040  r5 : c0321618  r4 : c388bc80
r3 : 60000093  r2 : 60000093  r1 : 00000000  r0 : 00000000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0000397f  Table: a3b34000  DAC: 00000015
Process kbnepd bnep0 (pid: 782, stack limit = 0xc3b2c268)
Stack: (0xc3b2def0 to 0xc3b2e000)
dee0:                                     c3b2df34 c3b2df00 c004f9c4 c0086bac
df00: 00000100 00000000 ffffffff ffffffff fffffeff ffffffff c0041510 c3b2c000
df20: c3b2c000 c3a89b20 c3b2df4c c3b2df38 c00367b4 c004f8b8 c031cf60 c031cf60
df40: c3b2df74 c3b2df50 c00380a4 c00366c8 00000000 ffffffff ffffffff c3b2df7c
df60: 00000000 00000000 c3b2dff4 c3b2df88 c024f54c c0037f84 c0301d48 c3a89800
df80: c3a89800 c34e11c0 c3b2dfac c3b2df98 c3a89800 c002d380 00000000 00000000
dfa0: 00000000 c3b2dfb0 c0020ea4 c002dfd8 00000000 c3a89b20 c024f514 c0037b24
dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
dfe0: 00000000 00000000 00000000 c3b2dff8 c0037b24 c024f520 00000000 00000000
Backtrace:
[<c0086ba0>] (set_dumpable+0x0/0xbc) from [<c004f9c4>]
(commit_creds+0x118/0x220)
[<c004f8ac>] (commit_creds+0x0/0x220) from [<c00367b4>]
(reparent_to_kthreadd+0xf8/0x130)
 r6:c3a89b20 r5:c3b2c000 r4:c3b2c000
[<c00366bc>] (reparent_to_kthreadd+0x0/0x130) from [<c00380a4>]
(daemonize+0x130/0x144)
 r4:c031cf60
[<c0037f74>] (daemonize+0x0/0x144) from [<c024f54c>] (bnep_session+0x38/0x6e8)
 r3:c34e11c0 r2:c3a89800 r1:c3a89800 r0:c0301d48
 r5:00000000 r4:00000000
[<c024f514>] (bnep_session+0x0/0x6e8) from [<c0037b24>] (do_exit+0x0/0x26c)
Code: 1a000024 e10f2000 e3823080 e121f003 (e5903150)
---[ end trace 6b6196f25f5ef011 ]---
note: kbnepd bnep0[782] exited with preempt_count 1

I then bisected this and got the following result appended below. I
haven't understood what is going on and whether it is a bluetooth
issue or something else. I'll look into it more tomorrow but would
appreciate any advice.

Thanks,
jaya

$ after having pulled mainline
$ git bisect bad
$ git bisect good ab65387243f47a7bc11725f733c86bf27248b326
<snip many iterations>
$ git-bisect bad
d84f4f992cbd76e8f39c488cf0c5d123843923b1 is first bad commit
commit d84f4f992cbd76e8f39c488cf0c5d123843923b1
Author: David Howells <dhowells@redhat.com>
Date:   Fri Nov 14 10:39:23 2008 +1100

    CRED: Inaugurate COW credentials

    Inaugurate copy-on-write credentials management.  This uses RCU to
manage the
    credentials pointer in the task_struct with respect to accesses by
other tasks.
    A process may only modify its own credentials, and so does not
need locking to
    access or modify its own credentials.

    A mutex (cred_replace_mutex) is added to the task_struct to
control the effect
    of PTRACE_ATTACHED on credential calculations, particularly with respect to
    execve().

    With this patch, the contents of an active credentials struct may not be
    changed directly; rather a new set of credentials must be prepared, modified
    and committed using something like the following sequence of events:

    	struct cred *new = prepare_creds();
    	int ret = blah(new);
    	if (ret < 0) {
    		abort_creds(new);
    		return ret;
    	}
    	return commit_creds(new);

    There are some exceptions to this rule: the keyrings pointed to by
the active
    credentials may be instantiated - keyrings violate the COW rule as managing
    COW keyrings is tricky, given that it is possible for a task to
directly alter
    the keys in a keyring in use by another task.

    To help enforce this, various pointers to sets of credentials,
such as those in
    the task_struct, are declared const.  The purpose of this is compile-time
    discouragement of altering credentials through those pointers.
Once a set of
    credentials has been made public through one of these pointers, it
may not be
    modified, except under special circumstances:

      (1) Its reference count may incremented and decremented.

      (2) The keyrings to which it points may be modified, but not replaced.

    The only safe way to modify anything else is to create a
replacement and commit
    using the functions described in Documentation/credentials.txt
(which will be
    added by a later patch).

    This patch and the preceding patches have been tested with the LTP SELinux
    testsuite.

    This patch makes several logical sets of alteration:

     (1) execve().

         This now prepares and commits credentials in various places in the
         security code rather than altering the current creds directly.

     (2) Temporary credential overrides.

         do_coredump() and sys_faccessat() now prepare their own credentials and
         temporarily override the ones currently on the acting thread, whilst
         preventing interference from other threads by holding
cred_replace_mutex
         on the thread being dumped.

         This will be replaced in a future patch by something that
hands down the
         credentials directly to the functions being called, rather
than altering
         the task's objective credentials.

     (3) LSM interface.

         A number of functions have been changed, added or removed:

         (*) security_capset_check(), ->capset_check()
         (*) security_capset_set(), ->capset_set()

         	 Removed in favour of security_capset().

         (*) security_capset(), ->capset()

         	 New.  This is passed a pointer to the new creds, a pointer to the old
         	 creds and the proposed capability sets.  It should fill in the new
         	 creds or return an error.  All pointers, barring the pointer to the
         	 new creds, are now const.

         (*) security_bprm_apply_creds(), ->bprm_apply_creds()

         	 Changed; now returns a value, which will cause the process to be
         	 killed if it's an error.

         (*) security_task_alloc(), ->task_alloc_security()

         	 Removed in favour of security_prepare_creds().

         (*) security_cred_free(), ->cred_free()

         	 New.  Free security data attached to cred->security.

         (*) security_prepare_creds(), ->cred_prepare()

         	 New. Duplicate any security data attached to cred->security.

         (*) security_commit_creds(), ->cred_commit()

         	 New. Apply any security effects for the upcoming installation of new
         	 security by commit_creds().

         (*) security_task_post_setuid(), ->task_post_setuid()

         	 Removed in favour of security_task_fix_setuid().

         (*) security_task_fix_setuid(), ->task_fix_setuid()

         	 Fix up the proposed new credentials for setuid().  This is used by
         	 cap_set_fix_setuid() to implicitly adjust capabilities in line with
         	 setuid() changes.  Changes are made to the new credentials, rather
         	 than the task itself as in security_task_post_setuid().

         (*) security_task_reparent_to_init(), ->task_reparent_to_init()

         	 Removed.  Instead the task being reparented to init is referred
         	 directly to init's credentials.

    	 NOTE!  This results in the loss of some state: SELinux's osid no
    	 longer records the sid of the thread that forked it.

         (*) security_key_alloc(), ->key_alloc()
         (*) security_key_permission(), ->key_permission()

         	 Changed.  These now take cred pointers rather than task pointers to
         	 refer to the security context.

     (4) sys_capset().

         This has been simplified and uses less locking.  The LSM functions it
         calls have been merged.

     (5) reparent_to_kthreadd().

         This gives the current thread the same credentials as init by
simply using
         commit_thread() to point that way.

     (6) __sigqueue_alloc() and switch_uid()

         __sigqueue_alloc() can't stop the target task from changing its creds
         beneath it, so this function gets a reference to the
currently applicable
         user_struct which it then passes into the sigqueue struct it returns if
         successful.

         switch_uid() is now called from commit_creds(), and possibly should be
         folded into that.  commit_creds() should take care of protecting
         __sigqueue_alloc().

     (7) [sg]et[ug]id() and co and [sg]et_current_groups.

         The set functions now all use prepare_creds(), commit_creds() and
         abort_creds() to build and check a new set of credentials
before applying
         it.

         security_task_set[ug]id() is called inside the prepared section.  This
         guarantees that nothing else will affect the creds until
we've finished.

         The calling of set_dumpable() has been moved into commit_creds().

         Much of the functionality of set_user() has been moved into
         commit_creds().

         The get functions all simply access the data directly.

     (8) security_task_prctl() and cap_task_prctl().

         security_task_prctl() has been modified to return -ENOSYS if it doesn't
         want to handle a function, or otherwise return the return
value directly
         rather than through an argument.

         Additionally, cap_task_prctl() now prepares a new set of
credentials, even
         if it doesn't end up using it.

     (9) Keyrings.

         A number of changes have been made to the keyrings code:

         (a) switch_uid_keyring(), copy_keys(), exit_keys() and suid_keys() have
         	 all been dropped and built in to the credentials functions directly.
         	 They may want separating out again later.

         (b) key_alloc() and search_process_keyrings() now take a cred pointer
         	 rather than a task pointer to specify the security context.

         (c) copy_creds() gives a new thread within the same thread group a new
         	 thread keyring if its parent had one, otherwise it discards
the thread
         	 keyring.

         (d) The authorisation key now points directly to the
credentials to extend
         	 the search into rather pointing to the task that carries them.

         (e) Installing thread, process or session keyrings causes a new set of
         	 credentials to be created, even though it's not strictly
necessary for
         	 process or session keyrings (they're shared).

    (10) Usermode helper.

         The usermode helper code now carries a cred struct pointer in its
         subprocess_info struct instead of a new session keyring
pointer.  This set
         of credentials is derived from init_cred and installed on the
new process
         after it has been cloned.

         call_usermodehelper_setup() allocates the new credentials and
         call_usermodehelper_freeinfo() discards them if they haven't
been used.  A
         special cred function (prepare_usermodeinfo_creds()) is provided
         specifically for call_usermodehelper_setup() to call.

         call_usermodehelper_setkeys() adjusts the credentials to sport the
         supplied keyring as the new session keyring.

    (11) SELinux.

         SELinux has a number of changes, in addition to those to
support the LSM
         interface changes mentioned above:

         (a) selinux_setprocattr() no longer does its check for whether the
         	 current ptracer can access processes with the new SID inside the lock
         	 that covers getting the ptracer's SID.  Whilst this lock ensures that
         	 the check is done with the ptracer pinned, the result is only valid
         	 until the lock is released, so there's no point doing it inside the
         	 lock.

    (12) is_single_threaded().

         This function has been extracted from selinux_setprocattr()
and put into
         a file of its own in the lib/ directory as join_session_keyring() now
         wants to use it too.

         The code in SELinux just checked to see whether a task shared
mm_structs
         with other tasks (CLONE_VM), but that isn't good enough.  We
really want
         to know if they're part of the same thread group (CLONE_THREAD).

    (13) nfsd.

         The NFS server daemon now has to use the COW credentials to set the
         credentials it is going to use.  It really needs to pass the
credentials
         down to the functions it calls, but it can't do that until
other patches
         in this series have been applied.

    Signed-off-by: David Howells <dhowells@redhat.com>
    Acked-by: James Morris <jmorris@namei.org>
    Signed-off-by: James Morris <jmorris@namei.org>

:040000 040000 54679388642b328ef9f83053dda93cf7b384c1a1
1e05b20df131aaefbf47477df23a43372d49b892 M
                             fs
:040000 040000 46cecb343e899eaa0e7f3f02b5cc9fb47cb479bc
c481b615af67d685bc43cef14b7e65648804e5b9 M
                             include
:040000 040000 1d6d049a7c8b44de21955be33aa21601ffee4293
ca03e5d9b0fdbc36ef8414c8204c5f4028fc2450 M
                             init
:040000 040000 937d58d5ab517eb27639a1dbabd82badc22e1dd8
6a6c8ebb9b52adfb46a3dad4199f45255954ae4e M
                             kernel
:040000 040000 0be63d6096b307a9a7310cd4eeb127a22840522e
7a36c5d69683a45f541d03f288776591643218e5 M
                             lib
:040000 040000 999a868ad972b27cfca54865633b923530b3c870
e001b88d115944ba794ea0baf7d79332cd888feb M
                             net
:040000 040000 c1bfa8c31e4c2a0c24be160925b79090b5d40ac6
4ba0ca62e135723401853a45e7b97e4ab667b6fe M
                             security
