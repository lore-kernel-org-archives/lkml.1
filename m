Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZFDWmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZFDWmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZFDWmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:42:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17083 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZFDWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eQ4Mn5H+Lh1VIrRe39WzCDGwjiDJxO1fcPcI981BrAMwBvcCJD7okzAFNaxRdOClzR
         p//9Wkcqc9NoDKQIG2EALA/iJ7og3t82Q/ISjyRw6koV6K86+t8iC0xEfY3iJ/cePztN
         QMSD4IuJoWPIY/n32ggqw81iuhz+s4uJwgbbk=
Date: Fri, 5 Jun 2009 02:42:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090604224239.GA10666@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090604075532.GU9285@us.ibm.com> <alpine.LFD.2.01.0906040803410.4880@localhost.localdomain> <20090604213033.GZ9285@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604213033.GZ9285@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:30:33PM -0700, Matt Helsley wrote:
> On Thu, Jun 04, 2009 at 08:07:23AM -0700, Linus Torvalds wrote:
> > On Thu, 4 Jun 2009, Matt Helsley wrote:
> > > 
> > > Doesn't this pin the vfs mount of the executable for the lifetime of
> > > the task?
> > 
> > Well, yes, but so does the current code.
> 
> Not quite. The current code pins it as long as the corresponding VMAs
> are mapped -- not for the lifetime of the task.
> 
> > Sure, in _theory_ it can be a non-mmap executable (maybe people still have 
> > those old OMAGIC a.out executables), and in _theory_ you could unmap the 
> > executable even if it was originally mmap'ed, but neither of those is 
> > exactly common, are they?
> 
> Not common to my knowledge, no.
> 
> > 
> > So in practice, nothing has changed wrt lifetime of the executable.
> 
> Almost all of the time, yes.

And year ago executable wasn't pinned at all, so if you're opposing
widening of time executable is pinned, you should revert your own patch
which introduced it in first place.

->exec_path merely makes /proc/*/exe very unheuristical (binfmt loader
decides, nothing else) and suitable for other code as demonstrated.
