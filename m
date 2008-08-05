Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbYHEO5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbYHEO5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbYHEO53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:57:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759315AbYHEO52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:57:28 -0400
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	foron access scanning
From: Eric Paris <eparis@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 10:56:52 -0400
Message-Id: <1217948212.27684.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 10:41 -0400, Press, Jonathan wrote:
> I share the concern here.  The idea that a piece of malware can exclude
> itself seems nasty to me.  I am not an expert on writing malware, but it
> intuitively seems to me to be a huge opportunity for creativity.  The
> argument that it's ok because anything that the malware writes will
> eventually be scanned anyway does not reassure me.

You aren't doing write time scanning anyway.  This exclusion means that
an 'excluded' process can OPEN things that would normally be called
malware.  The model here doesn't talk about adding files with bad
information to the system it talks about stopping that bad information
from being opened and propagated further.  Thread exclusions as they are
written in the patch only weaken security to those processes which
actively choose to read malware, it in no way weakens the security of
the system as a whole...
> 
> Also...  I was one of the people who brought up the idea of a process
> exclusion when the requirements list was being developed.  I intended it
> as a way that an AV application could exclude specific OTHER processes
> by name (as selected by the AV user) -- not as a way that a process
> would exclude itself.  I don't think that the implementation here
> reflects this goal, which still seems to me to be a requirement.

Wait wit, you'd rather have a 'privileged' process be allowed to exclude
every other process on a system than have a it only be allowed to
exclude itself? and somehow that is safer?

"by name" is right out the window.  You are never going to win 'by name'
on anything to do with the kernel  :)  Maybe you can get me to
eventually buy into 'by pid' or something like that, but setting flags
on other running processes is always going to be racy and scary for me.
Can you show me some code on how to do this cleanly?  And why it needs
to be done in kernel?

What is the goal you are trying to achieve?  A performance win for the
application in question or is this a security aware application that
needs to be able to access 'sensitive' data?

-Eric

