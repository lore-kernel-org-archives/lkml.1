Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbYGBHiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbYGBHiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYGBHiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:38:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653AbYGBHh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:37:59 -0400
Date: Wed, 2 Jul 2008 00:37:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
Message-Id: <20080702003755.4daff613.akpm@linux-foundation.org>
In-Reply-To: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 16:27:25 +1000 Paul Mackerras <paulus@samba.org> wrote:

> I'm being asked by library developers about what is the best way for
> them to get information about the CPU cache structure and the CPU
> topology from the kernel.  When I said "x86 puts it in sysfs and we'll
> do the same on powerpc" I got a response pointing me at this statement
> in Documentation/sysfs-rules.txt (the first paragraph):
> 
> "The kernel-exported sysfs exports internal kernel implementation details
>  and depends on internal kernel structures and layout. It is agreed upon
>  by the kernel developers that the Linux kernel does not provide a stable
>  internal API. As sysfs is a direct export of kernel internal
>  structures, the sysfs interface cannot provide a stable interface either;
>  it may always change along with internal kernel changes."

Those are dopey weasel words and they should be removed.

If we put stuff in sysfs then people WILL use it and we WILL need to
support it for ever.  Pointing at some document and saying "call my
lawyer" just won't cut it.

sysfs is part of the kernel ABI.  We should design our interfaces there
as carefully as we design any others.

> They read that to mean that sysfs is not a suitable interface for them
> to use to get information about the system.  In particular they read
> that to mean that if they do code their library to read sysfs, it will
> change in the future in such a way as to break their code.
> 
> In other words, they see sysfs as being completely useless for them
> because they can't depend on it as a stable interface.  Which is
> reasonable given the quoted paragraph, but on the other hand, I don't
> believe we break userspace interfaces as blithely as that paragraph
> suggests.

Well it's up to them - they own the files.  If they later change them
and break their own interfaces (and presumably their own applications),
well, perhaps they have chosen an inappropriate career?

> So which is it?  Can they rely on the CPU cache and topology
> information under /sys/devices/system/cpu/cpu*, and rely on having
> that information there essentially forever?  Or are they correct in
> saying sysfs is useless and we need to find some other way to expose
> the cache and topology information?

Use sysfs.  Choose a representation which is maitainable in a
backward-compatible fashion for all time.  Maintain it.

