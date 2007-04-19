Return-Path: <linux-kernel-owner+w=401wt.eu-S1766917AbXDSR5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766917AbXDSR5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766918AbXDSR5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:57:09 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:36144 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766917AbXDSR5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:57:07 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Crispin Cowan <crispin@novell.com>
Cc: David Safford <safford@watson.ibm.com>, James Morris <jmorris@namei.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <462553A9.70504@novell.com>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176822230.3366.65.camel@localhost.localdomain>
	 <462553A9.70504@novell.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 13:56:59 -0400
Message-Id: <1177005419.27654.157.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 16:09 -0700, Crispin Cowan wrote:
> David Safford wrote:
> > On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
> >   
> >> On Mon, 16 Apr 2007, John Johansen wrote:
> >>     
> >>> Label-based security (exemplified by SELinux, and its predecessors in
> >>> MLS systems) attaches security policy to the data. As the data flows
> >>> through the system, the label sticks to the data, and so security
> >>> policy with respect to this data stays intact. This is a good approach
> >>> for ensuring secrecy, the kind of problem that intelligence agencies have.
> >>>       
> >> Labels are also a good approach for ensuring integrity, which is one of 
> >> the most fundamental aspects of the security model implemented by SELinux.  
> >>
> >> Some may infer otherwise from your document.
> >>     
> > In fact, I am not sure how you can provide integrity support without
> > labels. AppArmor confines a process, but does not effectively confine 
> > its output files, precisely because the output files are not labeled. 
> > Other processes are free to access the unlabeled, potentially malicious 
> > output files without restriction. 
> >   
> That depends on what you mean by "integrity." It is true that AppArmor
> does not directly manage information flow. AppArmor assumes that if you
> granted write permission to /etc/resolv.conf, that you meant to do that.
> Whether any other process is permitted to access /etc/resolv.conf is
> determined by those other process's respective profiles.

Integrity protection requires information flow control; you can't
protect a high integrity process from being corrupted by a low integrity
process if you don't control the flow of information.  Plenty of attacks
take the form of a untrusted process injecting data that will ultimately
be used by a more trusted process with a surprising side effect.

And you can't do information flow control if you can't provide global
and persistent protection of the data, which requires labeling it and
preserving that label for its lifetime.

> What AppArmor provides is a way for administrators to confine software
> that they have to run but do not trust. The use of pathnames means that
> the administrator can understand the exact meaning of the security
> policy, without having to do a complete labeling of the file system. The
> flip side of not managing information flow is that each profile is
> independent of every other profile.

They aren't truly independent; the composition may lead to surprising
results where each individual program is "confined" exactly as you
specified, but in combination, one is able to corrupt the higher
integrity subject by actions taken by the lower integrity subject.
Particularly in the fun area of publically writable directories, where
pathnames are largely useless as an indicator.

-- 
Stephen Smalley
National Security Agency

