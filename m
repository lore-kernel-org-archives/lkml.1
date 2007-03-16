Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbXCPTrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbXCPTrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXCPTq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:46:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48460 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbXCPTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:46:58 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@sw.ru
In-Reply-To: <m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <1173806793.6680.44.camel@localhost.localdomain>
	 <20070313190931.1417c012@lxorguk.ukuu.org.uk>
	 <m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
	 <1174062660.8184.8.camel@localhost.localdomain>
	 <m1tzwlm33i.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 12:46:52 -0700
Message-Id: <1174074412.8184.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 12:54 -0600, Eric W. Biederman wrote:
> Dave Hansen <hansendc@us.ibm.com> writes:
> > http://linux-mm.org/SoftwareZones

> Looking at your page, and I'm too lazy to figure out how to update it
> I have a couple of comments.

You just need to create an account by clicking the Login button.  It
lets you edit things after that.  But, I'd be happy to put anything in
there you see fit.  

> - Why do limits have to apply to the unmapped page cache?

To me, it is just because it consumes memory.  Unmapped cache is, of
couse, much more easily reclaimed than mapped files, but it still
fundamentally causes pressure on the VM.  

To me, a process sitting there doing constant reads of 10 pages has the
same overhead to the VM as a process sitting there with a 10 page file
mmaped, and reading that.

> - Could you mention proper multi process RSS limits.
>   (I.e.  we count the number of pages each group of processes have mapped
>    and limit that).
>   It is the same basic idea as partial page ownership, but instead of
>   page ownership you just count how many pages each group is using and
>   strictly limit that.  There is no page owner ship or partial charges.
>   The overhead is just walking the rmap list at map and unmap time to
>   see if this is the first users in the container.  No additional kernel
>   data structures are needed.

I've tried to capture this.  Let me know what else you think it needs.

http://linux-mm.org/SoftwareZones

-- Dave

