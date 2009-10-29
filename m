Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZJ2TTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZJ2TTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZJ2TTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421AbZJ2TTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:19:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
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
In-Reply-To: Ingo Molnar's message of  Thursday, 29 October 2009 09:53:48 +0100 <20091029085348.GD26970@elte.hu>
References: <20091027204156.30545.96425.stgit@harusame>
	<20091029085348.GD26970@elte.hu>
X-Shopping-List: (1) Urgent digressions
   (2) Allegorical bits
   (3) Lucky hamster-lips
Message-Id: <20091029191801.CADC3538@magilla.sf.frob.com>
Date: Thu, 29 Oct 2009 12:18:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thirdly, i think we should expose the build-id of the kernel and the 
> path to the vmlinux (and modules) via /proc/build-id or so. That way 
> tooling can find the vmlinux file and can validate that it matches the 
> kernel's signature. (maybe include a file date as well - that's a faster 
> check than a full build-id checksum, especially for large kernels)

You seem to be confused about what build IDs are.  There is no "checksum
validation".  Once the bits are stored there is no calculation ever done
again, only exact comparison with an expected build ID bitstring.  The size
of an object file is immaterial.

As Frank mentioned, the kernel's and modules' allocated ELF notes (and thus
build IDs) are already exposed in /sys.  Tools like "eu-unstrip -nk" use
this information today.


Thanks,
Roland
