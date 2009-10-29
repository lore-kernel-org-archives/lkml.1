Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZJ2PKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZJ2PKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZJ2PKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:10:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZJ2PKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:10:31 -0400
Date: Thu, 29 Oct 2009 13:10:15 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
Message-ID: <20091029151014.GA7266@ghostprotocols.net>
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029085348.GD26970@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 29, 2009 at 09:53:48AM +0100, Ingo Molnar escreveu:
> Thirdly, i think we should expose the build-id of the kernel and the 
> path to the vmlinux (and modules) via /proc/build-id or so. That way 
> tooling can find the vmlinux file and can validate that it matches the 
> kernel's signature. (maybe include a file date as well - that's a faster 
> check than a full build-id checksum, especially for large kernels)

Yeah, build-id need to be a first class citizen, being always available for
checking that the DSO in disk matches the one being currently used by some app.

Right now I got myself staring at these messages in a perf top session:

No symbols found in /usr/lib/libvte.so.9.6.0 (deleted), maybe install a debug package?
No symbols found in /lib/libgobject-2.0.so.0.2000.5.#prelink#.MDypV3 (deleted), maybe install a debug package?
No symbols found in /usr/lib/libpixman-1.so.0.14.0 (deleted), maybe install a debug package?
No symbols found in /usr/lib/libgdk-x11-2.0.so.0.1600.6.#prelink#.4CriMV (deleted), maybe install a debug package?
No symbols found in /lib/libgthread-2.0.so.0.2000.5.#prelink#.0ooYbx (deleted), maybe install a debug package?
No symbols found in /usr/lib/libX11.so.6.2.0 (deleted), maybe install a debug package?
No symbols found in /usr/lib/libxcb.so.1.1.0 (deleted), maybe install a debug package?

Well, I did a 'yum upgrade' and there are some binaries still running that hold
reference counts to those DSOs, but there is not anymore any place I can look
for its buildid to get the right symtab.

Corner case, yeah, but it would be nice to be able to query for its buildid and
then get the right symtab.

But as we don't have that, I'll just look for (deleted) at the end of the DSO
name and emit a more friendly warning...

- Arnaldo
