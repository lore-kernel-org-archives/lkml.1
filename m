Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXDQPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXDQPDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXDQPDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:03:12 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:33919 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbXDQPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:03:10 -0400
Subject: Re: AppArmor FAQ
From: David Safford <safford@watson.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <Line.LNX.4.64.0704161846110.13905@d.namei>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Apr 2007 11:03:50 -0400
Message-Id: <1176822230.3366.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
> On Mon, 16 Apr 2007, John Johansen wrote:
> 
> > Label-based security (exemplified by SELinux, and its predecessors in
> > MLS systems) attaches security policy to the data. As the data flows
> > through the system, the label sticks to the data, and so security
> > policy with respect to this data stays intact. This is a good approach
> > for ensuring secrecy, the kind of problem that intelligence agencies have.
> 
> Labels are also a good approach for ensuring integrity, which is one of 
> the most fundamental aspects of the security model implemented by SELinux.  
> 
> Some may infer otherwise from your document.

In fact, I am not sure how you can provide integrity support without
labels. AppArmor confines a process, but does not effectively confine 
its output files, precisely because the output files are not labeled. 
Other processes are free to access the unlabeled, potentially malicious 
output files without restriction. 

> Imagine if you were re-inventing Unix and decided to implement pathname 
> security for DAC instead of inode labeling.  What you would have is a more 
> generalized version of apparmor, with the DAC attributes of pathnames for 
> the entire filesystem stored in a text database with an in-kernel regex 
> engine performing path reconstruction and pattern matching on every file 
> access.  Sound like a good idea?  I hope not.

Actually, this is pretty much how z/OS/RACF works. Labels and pathnames
for all files are stored in one database. There are advantages and 
disadvantages to this design, but is does work, and does have an EAL4+ 
certification on a Labeled Security Protection Profile.

> And you can still use pathnames under SELinux to locate an object to 
> label, just as you do with DAC.  You just don't put a security label on 
> the path itself.

SELinux _has_ to use pathnames to fix some ugly cases where new files
are created with the wrong label. It uses restorecond to fix the labels
for files such as resolv.conf, mtab, utab, and wtab, when they are 
created. The restorecond policy file is textual, and separate from the 
SELinux labels, which is somewhat inelegant.

RACF provides both labels and canonical paths for all files in one
location. There is no false dichotomy between path based and label 
based security. I don't know how to do this in Linux, with namespaces, 
mounts, and symlinks, but the concept is an interesting counterpoint 
in the discussion.

dave

