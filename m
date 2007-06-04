Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbXFDVDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbXFDVDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXFDVDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:03:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:51289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXFDVDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:03:30 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Mon, 4 Jun 2007 23:03:28 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <20070514110621.655650997@suse.de> <20070515092010.GE6816@ucw.cz>
In-Reply-To: <20070515092010.GE6816@ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2835
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706042303.28785.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007 11:20, Pavel Machek wrote:
> Hi!
> 
> > Pathname matching, transition table loading, profile loading and
> > manipulation.
> 
> So we get small interpretter of state machines, and reason we need is
> is 'apparmor is misdesigned and works with paths when it should have
> worked with handles'.

I assume you mean labels instead of handles.

AppArmor's design is around paths not labels, and independent of whether or 
not you like AppArmor, this design leads to a useful security model distinct 
from the SELinux security model (which is useful in its own ways). The 
differences between those models cannot be argued away, neither is a subset 
of the other, and neither is a misdesign. I would be thankful if you could 
stop spreading this lie.

> If you solve the 'new file problem', aa becomes subset of selinux.
> And I'm pretty sure patch will be nicer than this. 

You are quite mistaken. SELinux turns pathnames into labels when it initially 
labels all files (when a policy is rolled out), whereas AppArmor computes 
the "label" of each file when a file is opened. The two models start to 
diverge as soon as files are renamed: in SELinux, labels stick with the 
files. In AppArmor, "labels" stick with the names.

So what you advocate for is a hybrid between the SELinux and the AppArmor 
model, not a superset.

It could be that the SELinux folks will solve the issues they are having with 
new files using something better than restorecond in the future, perhaps even 
an in-kernel mechanism (although I somewhat doubt it). But then again, their 
basic model makes sense even without any live file relabeling, and so that's 
probably not very high up on the priority list.

Andreas
