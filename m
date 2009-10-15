Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbZJOL06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbZJOL06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZJOL05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:26:57 -0400
Received: from ozlabs.org ([203.10.76.45]:45853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973AbZJOL04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:26:56 -0400
Date: Thu, 15 Oct 2009 22:23:29 +1100
From: Anton Blanchard <anton@samba.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091015112329.GH4808@kryten>
References: <20091006064919.GB30316@wotan.suse.de> <20091015100854.GA19948@kryten> <20091015105332.GB3127@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20091015105332.GB3127@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 
Hi Nick,

> I wonder what other good performance tests you can add to your test
> framework? creat/unlink is another easy one. And for each case, putting
> threads in their own cwd versus a common cwd are the variants.

I did try the two combinations of creat/unlink but haven't had a chance to
digest the profiles yet. I've attached them (taken at 64 cores, ie worst
case :)

In both cases performance was significantly better than mainline.

> BTW. for these cases in your tests it will be nice if you can run on
> ramfs because that will isolate purely the vfs. Perhaps also include
> other filesystems as you get time, but I think ramfs is the most
> useful for us to start with.

Good point. I'll add that into the setup scripts.

Anton

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="open_unlink.profile"

# Samples: 82617
#
# Overhead          Command                      Shared Object  Symbol
# ........  ...............  .................................  ......
#
    99.16%  unlink1_process  [kernel]                           [k] ._spin_lock
                |          
                |--99.98%-- ._spin_lock
                |          |          
                |          |--49.80%-- .path_get
                |          |          (nil)
                |          |          |          
                |          |          |--71.62%-- .path_init
                |          |          |          |          
                |          |          |          |--51.37%-- .do_path_lookup
                |          |          |          |          .user_path_parent
                |          |          |          |          .do_unlinkat
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff8e90bd4c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff8e84f33c
                |          |          |          |          0xfff8e84f55c
                |          |          |          |          (nil)
                |          |          |          |          
                |          |          |           --48.63%-- .do_filp_open
                |          |          |                     .do_sys_open
                |          |          |                     syscall_exit
                |          |          |                     0xfff8e909c7c
                |          |          |                     .testcase
                |          |          |                     .affinitize
                |          |          |                     .new_task
                |          |          |                     .main
                |          |          |                     0xfff8e84f33c
                |          |          |                     0xfff8e84f55c
                |          |          |                     (nil)
                |          |          |          
                |          |           --28.38%-- .path_walk
                |          |                     |          
                |          |                     |--50.49%-- .do_filp_open
                |          |                     |          .do_sys_open
                |          |                     |          syscall_exit
                |          |                     |          0xfff8e909c7c
                |          |                     |          .testcase
                |          |                     |          .affinitize
                |          |                     |          .new_task
                |          |                     |          .main
                |          |                     |          0xfff8e84f33c
                |          |                     |          0xfff8e84f55c
                |          |                     |          (nil)
                |          |                     |          
                |          |                      --49.51%-- .do_path_lookup
                |          |                                .user_path_parent
                |          |                                .do_unlinkat
                |          |                                syscall_exit
                |          |                                0xfff8e90bd4c
                |          |                                .testcase
                |          |                                .affinitize
                |          |                                .new_task
                |          |                                .main
                |          |                                0xfff8e84f33c
                |          |                                0xfff8e84f55c
                |          |                                (nil)
                |          |          
                |          |--49.58%-- .dput
                |          |          (nil)
                |          |          |          
                |          |          |--64.21%-- .path_put
                |          |          |          |          
                |          |          |          |--48.48%-- .path_walk
                |          |          |          |          |          
                |          |          |          |          |--51.00%-- .do_path_lookup
                |          |          |          |          |          .user_path_parent
                |          |          |          |          |          .do_unlinkat
                |          |          |          |          |          syscall_exit
                |          |          |          |          |          0xfff8e90bd4c
                |          |          |          |          |          .testcase
                |          |          |          |          |          .affinitize
                |          |          |          |          |          .new_task
                |          |          |          |          |          .main
                |          |          |          |          |          0xfff8e84f33c
                |          |          |          |          |          0xfff8e84f55c
                |          |          |          |          |          (nil)
                |          |          |          |          |          
                |          |          |          |           --49.00%-- .do_filp_open
                |          |          |          |                     .do_sys_open
                |          |          |          |                     syscall_exit
                |          |          |          |                     0xfff8e909c7c
                |          |          |          |                     .testcase
                |          |          |          |                     .affinitize
                |          |          |          |                     .new_task
                |          |          |          |                     .main
                |          |          |          |                     0xfff8e84f33c
                |          |          |          |                     0xfff8e84f55c
                |          |          |          |                     (nil)
                |          |          |          |          
                |          |          |          |--25.79%-- .do_filp_open
                |          |          |          |          .do_sys_open
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff8e909c7c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff8e84f33c
                |          |          |          |          0xfff8e84f55c
                |          |          |          |          (nil)
                |          |          |          |          
                |          |          |          |--25.72%-- .do_path_lookup
                |          |          |          |          .user_path_parent
                |          |          |          |          .do_unlinkat
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff8e90bd4c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff8e84f33c
                |          |          |          |          0xfff8e84f55c
                |          |          |          |          (nil)
                |          |          |           --0.00%-- [...]
                |          |          |          
                |          |          |--35.78%-- .__link_path_walk
                |          |          |          .path_walk
                |          |          |          |          
                |          |          |          |--50.81%-- .do_path_lookup
                |          |          |          |          .user_path_parent
                |          |          |          |          .do_unlinkat
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff8e90bd4c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff8e84f33c
                |          |          |          |          0xfff8e84f55c
                |          |          |          |          (nil)
                |          |          |          |          
                |          |          |           --49.19%-- .do_filp_open
                |          |          |                     .do_sys_open
                |          |          |                     syscall_exit
                |          |          |                     0xfff8e909c7c
                |          |          |                     .testcase
                |          |          |                     .affinitize
                |          |          |                     .new_task
                |          |          |                     .main
                |          |          |                     0xfff8e84f33c
                |          |          |                     0xfff8e84f55c
                |          |          |                     (nil)
                |          |           --0.01%-- [...]
                |           --0.62%-- [...]
                 --0.02%-- [...]

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="open_unlink_directories.profile"
Content-Transfer-Encoding: quoted-printable

# Samples: 101253
#
# Overhead          Command                      Shared Object  Symbol
# ........  ...............  .................................  ......
#
=1B[31m    99.15%=1B[m  unlink2_process  [kernel]                          =
 [k] ._spin_lock
                |         =20
                |=1B[31m--99.97%-- =1B[m._spin_lock
                |          |         =20
                |          |=1B[31m--49.96%-- =1B[m.dput
                |          |          (nil)
                |          |          |         =20
                |          |          |=1B[31m--71.64%-- =1B[m.__link_path_=
walk
                |          |          |          .path_walk
                |          |          |          |         =20
                |          |          |          |=1B[31m--50.78%-- =1B[m.d=
o_path_lookup
                |          |          |          |          .user_path_pare=
nt
                |          |          |          |          .do_unlinkat
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff86a85d4c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff869c933c
                |          |          |          |          0xfff869c955c
                |          |          |          |          (nil)
                |          |          |          |         =20
                |          |          |           =1B[31m--49.22%-- =1B[m.d=
o_filp_open
                |          |          |                     .do_sys_open
                |          |          |                     syscall_exit
                |          |          |                     0xfff86a83c7c
                |          |          |                     .testcase
                |          |          |                     .affinitize
                |          |          |                     .new_task
                |          |          |                     .main
                |          |          |                     0xfff869c933c
                |          |          |                     0xfff869c955c
                |          |          |                     (nil)
                |          |          |         =20
                |          |          |=1B[31m--28.35%-- =1B[m.path_put
                |          |          |          |         =20
                |          |          |          |=1B[31m--50.91%-- =1B[m.p=
ath_walk
                |          |          |          |          |         =20
                |          |          |          |          |=1B[31m--53.90=
%-- =1B[m.do_path_lookup
                |          |          |          |          |          .use=
r_path_parent
                |          |          |          |          |          .do_=
unlinkat
                |          |          |          |          |          sysc=
all_exit
                |          |          |          |          |          0xff=
f86a85d4c
                |          |          |          |          |          .tes=
tcase
                |          |          |          |          |          .aff=
initize
                |          |          |          |          |          .new=
_task
                |          |          |          |          |          .main
                |          |          |          |          |          0xff=
f869c933c
                |          |          |          |          |          0xff=
f869c955c
                |          |          |          |          |          (nil)
                |          |          |          |          |         =20
                |          |          |          |           =1B[31m--46.10=
%-- =1B[m.do_filp_open
                |          |          |          |                     .do_=
sys_open
                |          |          |          |                     sysc=
all_exit
                |          |          |          |                     0xff=
f86a83c7c
                |          |          |          |                     .tes=
tcase
                |          |          |          |                     .aff=
initize
                |          |          |          |                     .new=
_task
                |          |          |          |                     .main
                |          |          |          |                     0xff=
f869c933c
                |          |          |          |                     0xff=
f869c955c
                |          |          |          |                     (nil)
                |          |          |          |         =20
                |          |          |          |=1B[31m--25.98%-- =1B[m.d=
o_filp_open
                |          |          |          |          .do_sys_open
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff86a83c7c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff869c933c
                |          |          |          |          0xfff869c955c
                |          |          |          |          (nil)
                |          |          |          |         =20
                |          |          |          |=1B[31m--23.10%-- =1B[m.d=
o_path_lookup
                |          |          |          |          .user_path_pare=
nt
                |          |          |          |          .do_unlinkat
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff86a85d4c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff869c933c
                |          |          |          |          0xfff869c955c
                |          |          |          |          (nil)
                |          |          |           --0.01%-- [...]
                |          |           --0.01%-- [...]
                |          |         =20
                |          |=1B[31m--28.88%-- =1B[m.__follow_mount
                |          |          (nil)
                |          |          .do_lookup
                |          |          .__link_path_walk
                |          |          .path_walk
                |          |          |         =20
                |          |          |=1B[31m--50.26%-- =1B[m.do_filp_open
                |          |          |          .do_sys_open
                |          |          |          syscall_exit
                |          |          |          0xfff86a83c7c
                |          |          |          .testcase
                |          |          |          .affinitize
                |          |          |          .new_task
                |          |          |          .main
                |          |          |          0xfff869c933c
                |          |          |          0xfff869c955c
                |          |          |          (nil)
                |          |          |         =20
                |          |           =1B[31m--49.74%-- =1B[m.do_path_look=
up
                |          |                     .user_path_parent
                |          |                     .do_unlinkat
                |          |                     syscall_exit
                |          |                     0xfff86a85d4c
                |          |                     .testcase
                |          |                     .affinitize
                |          |                     .new_task
                |          |                     .main
                |          |                     0xfff869c933c
                |          |                     0xfff869c955c
                |          |                     (nil)
                |          |         =20
                |          |=1B[31m--20.33%-- =1B[m.path_get
                |          |          (nil)
                |          |          |         =20
                |          |          |=1B[31m--69.39%-- =1B[m.path_init
                |          |          |          |         =20
                |          |          |          |=1B[31m--50.78%-- =1B[m.d=
o_path_lookup
                |          |          |          |          .user_path_pare=
nt
                |          |          |          |          .do_unlinkat
                |          |          |          |          syscall_exit
                |          |          |          |          0xfff86a85d4c
                |          |          |          |          .testcase
                |          |          |          |          .affinitize
                |          |          |          |          .new_task
                |          |          |          |          .main
                |          |          |          |          0xfff869c933c
                |          |          |          |          0xfff869c955c
                |          |          |          |          (nil)
                |          |          |          |         =20
                |          |          |           =1B[31m--49.22%-- =1B[m.d=
o_filp_open
                |          |          |                     .do_sys_open
                |          |          |                     syscall_exit
                |          |          |                     0xfff86a83c7c
                |          |          |                     .testcase
                |          |          |                     .affinitize
                |          |          |                     .new_task
                |          |          |                     .main
                |          |          |                     0xfff869c933c
                |          |          |                     0xfff869c955c
                |          |          |                     (nil)
                |          |          |         =20
                |          |           =1B[31m--30.61%-- =1B[m.path_walk
                |          |                     |         =20
                |          |                     |=1B[31m--53.29%-- =1B[m.d=
o_filp_open
                |          |                     |          .do_sys_open
                |          |                     |          syscall_exit
                |          |                     |          0xfff86a83c7c
                |          |                     |          .testcase
                |          |                     |          .affinitize
                |          |                     |          .new_task
                |          |                     |          .main
                |          |                     |          0xfff869c933c
                |          |                     |          0xfff869c955c
                |          |                     |          (nil)
                |          |                     |         =20
                |          |                      =1B[31m--46.71%-- =1B[m.d=
o_path_lookup
                |          |                                .user_path_pare=
nt
                |          |                                .do_unlinkat
                |          |                                syscall_exit
                |          |                                0xfff86a85d4c
                |          |                                .testcase
                |          |                                .affinitize
                |          |                                .new_task
                |          |                                .main
                |          |                                0xfff869c933c
                |          |                                0xfff869c955c
                |          |                                (nil)
                |           =1B[32m--0.83%-- =1B[m[...]
                 --0.03%-- [...]

--sm4nu43k4a2Rpi4c--
