Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbZCYOpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbZCYOpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759165AbZCYOpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:45:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57683 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756366AbZCYOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:45:06 -0400
Date: Wed, 25 Mar 2009 10:45:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alex Chiang <achiang@hp.com>
cc: htejun@gmail.com, <greg@kroah.com>, <cornelia.huck@de.ibm.com>,
       <kay.sievers@vrfy.org>, <rusty@rustcorp.com.au>,
       <ebiederm@xmission.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
In-Reply-To: <20090325035707.15921.42150.stgit@bob.kio>
Message-ID: <Pine.LNX.4.44L0.0903251036450.3462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, Alex Chiang wrote:

> Hi all,
> 
> This is a refreshed version of the patch series Tejun posted quite a while
> ago that allowed sysfs attributes to commit suicide directly:
> 
> 	http://thread.gmane.org/gmane.linux.kernel/582130/

> The most contentious part is patch 1/3, wherein sysfs abuses the
> module notifier call chain, and basically prevents all module unloads
> until suicidal sysfs attributes have completed.
> 
> This is poison of a different flavor from last time. The earlier version
> of this series modified the module API and created an interface that
> allowed anyone to inhibit module unload.
> 
> This time, only sysfs is allowed to be so... special. Which is a slight
> improvement, but the question as to whether sysfs should be allowed to
> do something like this is unresolved.

I tend to agree with Eric that this feels a little like a band-aid, and 
a more general solution would be preferable.  But I don't have one to 
offer, and getting the immediate problems fixed is also important.

Why change the inhibit-module-unload interface?  This new approach
seems a lot more complicated than needed; a simple rwsem should work
okay.  Exposing it to the entire kernel when only sysfs uses it doesn't 
matter -- there must be plenty of EXPORTed symbols with only one user.

Which reminds me...  What happens if two different processes write to
the same suicidal sysfs attribute at the same time?

Alan Stern

