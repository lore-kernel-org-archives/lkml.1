Return-Path: <linux-kernel-owner+w=401wt.eu-S1031107AbXDQQEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031107AbXDQQEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031116AbXDQQEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:04:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031114AbXDQQD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:03:58 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: David Safford <safford@watson.ibm.com>
Cc: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1176822230.3366.65.camel@localhost.localdomain>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176822230.3366.65.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 12:00:41 -0400
Message-Id: <1176825641.5946.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 11:03 -0400, David Safford wrote:
> On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
> > On Mon, 16 Apr 2007, John Johansen wrote:
> > 
> Actually, this is pretty much how z/OS/RACF works. Labels and pathnames
> for all files are stored in one database. There are advantages and 
> disadvantages to this design, but is does work, and does have an EAL4+ 
> certification on a Labeled Security Protection Profile.
> 
> > And you can still use pathnames under SELinux to locate an object to 
> > label, just as you do with DAC.  You just don't put a security label on 
> > the path itself.
> 
> SELinux _has_ to use pathnames to fix some ugly cases where new files
> are created with the wrong label. It uses restorecond to fix the labels
> for files such as resolv.conf, mtab, utab, and wtab, when they are 
> created. The restorecond policy file is textual, and separate from the 
> SELinux labels, which is somewhat inelegant.
> 

No - the real fix is to change the applications or to run under a policy
that confines all applications. Most of the problems with resolv.conf,
mtab, etc. stem from admin processes (e.g., editors or shell scripts)
all running under the same unconfined domain.

In some cases applications need modification as only the application has
enough information to determine the correct label. Usually this means
preserving labels from input files or separating the output into
distinct directories so type transitions or label inheritance will work.

restorecond is just a hack not a requirement or a sign that something is
wrong with the model. That is why it is a userspace application and not
integrated into the kernel mechanism.

Karl

