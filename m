Return-Path: <linux-kernel-owner+w=401wt.eu-S932800Ab0AGBqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0AGBqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435Ab0AGBqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:46:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab0AGBqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:46:12 -0500
Date: Wed, 6 Jan 2010 18:59:11 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tools/perf: "perf record" restricted to root in latest kernel?
Message-ID: <20100106205911.GC18919@ghostprotocols.net>
References: <buopr5nol26.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <buopr5nol26.fsf@dhlpc061.dev.necel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 06, 2010 at 02:32:17PM +0900, Miles Bader escreveu:
> I tried compiling tools/perf in an old linux source tree (ab86e5765,
> roughly 2.6.31), and the resulting perf tool seemed to work fine
> ("perf record" ... "perf report", "perf stat" etc); I ran it as an
> ordinary user.
> 
> Next I updated to the latest linus tree (c5974b835a), and recompiled perf.
> It still seems to work, and has obviously had a lot of features added, but
> now it only wants to let me run "perf record" if I'm root.  This is
> slightly annoying -- even if I use "sudo" or make it setuid, it still ends
> up generating an output file owned by root, etc.
> 
> In both cases, I'm using the same kernel (I only recompiled the tool), 2.6.32.
> 
> I used no options with "perf record", just gave the command I wanted to profile.
> 
> Is there a reason why the newer version perf tool restricts "perf record"
> to root, especially given that the older version still seems to work fine
> as non-root?

Don't recall noticing such problem, here it works just fine:

[acme@doppio linux-2.6-tip]$ mkdir tmp
[acme@doppio linux-2.6-tip]$ cd tmp
[acme@doppio tmp]$ time perf record find ~/git/ > /dev/null
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.053 MB perf.data (~2312 samples) ]

real	0m25.602s
user	0m0.007s
sys	0m0.020s
[acme@doppio tmp]$ perf report | head -13
# Samples: 1628008142
#
# Overhead  Command           Shared Object  Symbol
# ........  .......  ......................  ......
#
     6.03%     find  libc-2.10.2.so          [.] _IO_vfprintf_internal
     5.70%     find  find                    [.] 0x0000000000351d
     3.39%     find  [kernel]                [k] ext4_htree_store_dirent
     2.85%     find  [kernel]                [k] __kmalloc
     2.14%     find  [kernel]                [k] _raw_spin_lock
     2.10%     find  [kernel]                [k] read_hpet
     2.10%     find  [kernel]                [k] half_md4_transform
     2.08%     find  libc-2.10.2.so          [.] __GI_memmove
[acme@doppio tmp]$ perf report --sort dso
# Samples: 1628008142
#
# Overhead                Shared Object
# ........  ...........................
#
    74.66%  [kernel]                   
    16.74%  libc-2.10.2.so             
     7.59%  find                       
     0.72%  ld-2.10.2.so               
     0.29%  libpthread-2.10.2.so       
[acme@doppio tmp]$ cd ..
[acme@doppio linux-2.6-tip]$ uname -r
2.6.33-rc3-tip+
[acme@doppio linux-2.6-tip]$ git branch | grep ^\*
* perf
[acme@doppio linux-2.6-tip]$ cat .git/refs/heads/perf
1dcff0bf19619e4d7bc61628770e6d88c631015c
[acme@doppio linux-2.6-tip]$

- Arnaldo
