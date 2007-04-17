Return-Path: <linux-kernel-owner+w=401wt.eu-S1161396AbXDQW3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161396AbXDQW3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161391AbXDQW3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:29:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161384AbXDQW3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:29:50 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: James Morris <jmorris@namei.org>, David Safford <safford@watson.ibm.com>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070417181016.GA10903@one.firstfloor.org>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176822230.3366.65.camel@localhost.localdomain>
	 <1176825641.5946.41.camel@localhost.localdomain>
	 <p73abx66fme.fsf@bingen.suse.de>
	 <Line.LNX.4.64.0704171323090.19432@d.namei>
	 <20070417181016.GA10903@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 18:26:24 -0400
Message-Id: <1176848784.5946.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 20:10 +0200, Andi Kleen wrote:
> On Tue, Apr 17, 2007 at 01:47:39PM -0400, James Morris wrote:
> > Normal applications need zero modification under SELinux.
> > 
> > Some applications which manage security may need to be made SELinux-aware, 
> 
> Anything that can touch /etc/resolv.conf? That's potentially a lot of binaries
> if you consider anything scripts could do with it.
> 

Certainly not - most things are handled by policy. I don't think that
any applications shipped with Fedora are modified to handle resolv.conf.
They are either confined and policy takes care of it or, in the case of
things like vi, they are generically modified to preserve labels (and
that change is partially to accommodate the targeted policy). Any
application that preserves DAC mode bits should likely also preserve
ACLs and SELinux labels (I guess they should potentially just preserve
all xattrs - not certain).

> > although this can often be done with PAM plugins, which is a standard way 
> > to do this kind of thing in modern Unix & Linux OSs.
> 
> PAM plugins in vi and emacs? Scary idea.
> 

Err, no. I don't think that is what James was suggesting.

> And what do you do if someone decides to use OpenOffice to edit their
> /etc/resolv.conf? For a lot of people that's the only text editor 
> they know.
> 

Yeah right, I'm certain there are a lot of users (even clueless ones)
that use OO for files in /etc. I assume that line wrapping alone would
make this impossible and running a huge X application as root is
obviously not the best idea. Actually, it seems unlikely that a clueless
user would know how to run OO as root.

Anyway, general concerns aside, for a targeted system this would likely
just work depending on how OO saves files or whether it preserves
labels.

It would also be possible to create a small policy that defined a domain
for OO that would allow editing resolv.conf. If you went that route the
policy could set the label correctly. This is actually one of the major
advantages of SELinux. You can create multiple domains for the same app
that allow different actions depending on the circumstances.

Karl

