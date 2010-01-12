Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828Ab0ALDM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0ALDM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536Ab0ALDM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:12:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56215 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0ALDM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:12:27 -0500
Date: Tue, 12 Jan 2010 12:12:32 +0900 (JST)
Message-Id: <20100112.121232.189721840.d.hatayama@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhiramat@redhat.com,
       xiyou.wangcong@gmail.com, andi@firstfloor.org, jdike@addtoit.com,
       tony.luck@intel.com
Subject: Re: [RESEND][mmotm][PATCH v2, 0/5] elf coredump: Add extended
 numbering support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20100107162928.1d6eba76.akpm@linux-foundation.org>
References: <20100104.100607.189714443.d.hatayama@jp.fujitsu.com>
	<20100107162928.1d6eba76.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][mmotm][PATCH v2, 0/5] elf coredump: Add extended numbering support
Date: Thu, 7 Jan 2010 16:29:28 -0800

> On Mon, 04 Jan 2010 10:06:07 +0900 (JST)
> Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> wrote:
> 
> > The current ELF dumper can produce broken corefiles if program headers
> > exceed 65535. In particular, the program in 64-bit environment often
> > demands more than 65535 mmaps. If you google max_map_count, then you
> > can find many users facing this problem.
> > 
> > Solaris has already dealt with this issue, and other OSes have also
> > adopted the same method as in Solaris. Currently, Sun's document and
> > AMD 64 ABI include the description for the extension, where they call
> > the extension Extended Numbering. See Reference for further information.
> > 
> > I believe that linux kernel should adopt the same way as they did, so
> > I've written this patch.
> > 
> > I am also preparing for patches of GDB and binutils.
> 
> That's a beautifully presented patchset.  Thanks for doing all that
> work - it helps.
> 
> UML maintenance appears to have ceased in recent times, so if we wish
> to have these changes runtime tested (we should) then I think it would
> be best if you could find someone to do that please.
> 
> And no akpm code-review would be complete without: dump_seek() is
> waaaay to large to be inlined.  Is there some common .c file to where
> we could move it?
> 

I am sorry for very late reply.

* Patch Test for UML-i386

I tested on UML-i386 for the stable release of that time, precisely
2.6.32, since even building process for UML-i386 failed for mainline
and mmotm trees, as you've expected.

I don't know internal UML implementation at all, so I need to find
someone if runtime test for mmotm tree is absolutely necessary.

* modification for dump_seek()

I couldn't find any right .c file at which dump_seek() be placed. We
need to create a new .c file into which we put auxiliary functions to
generate/manipulate coredumps.

There is another problem regarding name space. The name dump_seek() is
too short.  If we move dump_seek() to some .c file, we need to rename
it according to the corresponding object file format, such as
elf_core_dump_seek() or aout_dump_seek(); or coredump_dump_seek(), as
currently dump_seek() is shared among dumping processes in multiple
object formats.

Should I submit these suggestions as a patch set of version 3?

Thanks
