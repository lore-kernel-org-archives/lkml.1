Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYFRTAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYFRTAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYFRTAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:00:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59825 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbYFRTAf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:00:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Significance Of sort() In include/linux/sort.h
In-Reply-To: Your message of "Wed, 18 Jun 2008 20:39:38 +0200."
             <Pine.LNX.4.64.0806152126001.6721@visualserver.org>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0806152126001.6721@visualserver.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1213815634_3203P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Jun 2008 15:00:34 -0400
Message-ID: <26220.1213815634@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1213815634_3203P
Content-Type: text/plain; charset=us-ascii

On Wed, 18 Jun 2008 20:39:38 +0200, Soumyadip Das Mahapatra said:
> Hello everybody,
>  	I dont understand what is the significance of keeping
> include/linux/sort.h and lib/sort.c while i think there is
> none using (#include<linux/sort.h>) it. Can anyone explaint it?

Huh? Am I missing something here?

[/usr/src/linux-2.6] find . -name '*.[ch]' | xargs grep linux/sort
./arch/x86/kernel/setup_64.c:#include <linux/sort.h>
./arch/x86/kernel/mmconf-fam10h_64.c:#include <linux/sort.h>
./arch/x86/kernel/test_nx.c:#include <linux/sort.h>
./arch/sparc/prom/memory.c:#include <linux/sort.h>
./arch/sparc64/mm/init.c:#include <linux/sort.h>
./arch/powerpc/kernel/module_32.c:#include <linux/sort.h>
./arch/powerpc/kernel/module_64.c:#include <linux/sort.h>
./arch/ia64/mm/extable.c:#include <linux/sort.h>
./kernel/cgroup.c:#include <linux/sort.h>
./kernel/cpuset.c:#include <linux/sort.h>
./kernel/lockdep_proc.c:#include <linux/sort.h>
./drivers/net/pppol2tp.c:#include <linux/sort.h>
./drivers/media/video/saa7134/saa7134-video.c:#include <linux/sort.h>
./drivers/media/video/v4l2-int-device.c:#include <linux/sort.h>
./drivers/message/fusion/mptfc.c:#include <linux/sort.h>
./lib/extable.c:#include <linux/sort.h>
./lib/sort.c:#include <linux/sort.h>
./fs/nfs_common/nfsacl.c:#include <linux/sort.h>
./fs/gfs2/glock.c:#include <linux/sort.h>
./fs/gfs2/inode.c:#include <linux/sort.h>
./fs/gfs2/quota.c:#include <linux/sort.h>
./fs/gfs2/dir.c:#include <linux/sort.h>
./fs/xfs/linux-2.6/xfs_linux.h:#include <linux/sort.h>
./mm/page_alloc.c:#include <linux/sort.h>

Lotta includes of the header.  And does anybody use the one function in it?
[/usr/src/linux-2.6] find . -name '*.c' | xargs grep 'sort(' | wc
     66     376    5054

[/usr/src/linux-2.6] find . -name '*.c' | xargs grep '[       ]sort(' | head
./arch/x86/kernel/mmconf-fam10h_64.c:   sort(range, hi_mmio_num, sizeof(struct range), cmp_range, NULL);
./arch/sparc/prom/memory.c:     sort(sp_banks, num_ents, sizeof(struct sparc_phys_banks),
./arch/sparc64/mm/init.c:       sort(regs, ents, sizeof(struct linux_prom64_registers),
./arch/sparc64/mm/init.c:       sort(prom_trans, ents, sizeof(struct linux_prom_translation),
./arch/powerpc/kernel/module_32.c:                      sort((void *)hdr + sechdrs[i].sh_offset,
./arch/powerpc/kernel/module_64.c:                      sort((void *)sechdrs[i].sh_addr,
./arch/ia64/mm/extable.c:       sort(start, finish - start, sizeof(struct exception_table_entry),
./kernel/cgroup.c:              sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
./kernel/lockdep_proc.c:                sort(data->stats, data->iter_end - data->iter,
./drivers/media/video/saa7134/saa7134-video.c:  sort(col, cols, sizeof col[0], cliplist_cmp, NULL);

Looks like people call it too.  OK, I admit I haven't gone and checked
whether all of those have #ifdef-0 magic around them that render them dead code,
but I suspect lots of them are live code...

What made you think it wasn't used?




--==_Exmh_1213815634_3203P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIWVtScC3lWbTT17ARAprNAKC6SJ0+gON82TvsHZsMoaL9xJPAVgCfeqZf
XrhTOqaBgnFy9R5Y4Rh0RDk=
=hY8D
-----END PGP SIGNATURE-----

--==_Exmh_1213815634_3203P--
