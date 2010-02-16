Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab0BPW3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:29:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:30645 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab0BPW3K (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 16 Feb 2010 17:29:10 -0500
Date: Tue, 16 Feb 2010 17:13:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [LKML] Re: [PATCH] x86_64: allow sections that are recycled to
	set _PAGE_RW
Message-ID: <20100216221313.GA22869@phenom.dumpdata.com>
References: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com> <1266030928-2126-2-git-send-email-konrad.wilk@oracle.com> <1266091697.2677.64.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266091697.2677.64.camel@sbs-t61>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B7B1C12.018A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 12:08:17PM -0800, Suresh Siddha wrote:
> Konrad,
> 
> I don't think this patch is correct.
> 
> I am not sure if I understand why we see this failure in Xen. In native
> case, we have two kernel mappings for 64bit kernel.
> 
> One is kernel text mapping:
> 
> ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from
> phys 0
> 
> And another is:
> 
> ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys.
> memory
> 
> Checks in static_protections() ensure that we map the text mapping as
> read-only (and don't bother about what permissions it uses for
> underlying free pages that get freed in free_init_pages()). But the
> kernel direct mappings for free pages will be RW and ensure that the
> free pages can be read/written using the direct mapping.
> 
> The checks in static_protections() for kernel text mapping ensure that
> we don't break the 2MB kernel text pages unnecessarily on 64bit kernels
> (as it has performance implications). We should be fine as long as the
> kernel identity mappings reflect the correct RW permissions.
> 
> But somehow this is working fine on native kernels but not on Xen pv
> guest. Your patch will cause the performance issues that we are

That would not be good.

> addressing using the static protections checks. I will look at this more
> detailed on tuesday.

Great. Thank you for doing that. If you find yourself in a bind, here are
some steps on how to build the Xen pv-ops kernel and such:
http://wiki.xensource.com/xenwiki/XenParavirtOps

It goes without saying that I would be happy to test your patch when
you have one ready.
