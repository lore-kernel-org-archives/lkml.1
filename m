Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbXFVMmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbXFVMmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXFVMl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:41:59 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:40280 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753412AbXFVMl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:41:58 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070622113727.GJ20105@marowsky-bree.de>
References: <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
	 <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
	 <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	 <20070621211743.GN20105@marowsky-bree.de>
	 <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
	 <20070622113727.GJ20105@marowsky-bree.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 22 Jun 2007 08:41:51 -0400
Message-Id: <1182516111.24664.72.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 13:37 +0200, Lars Marowsky-Bree wrote:
> On 2007-06-22T07:19:39, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > > > Or can access the data under a different path to which their profile
> > > > does give them access, whether in its final destination or in some
> > > > temporary file processed along the way.
> > > Well, yes. That is intentional.
> > > 
> > > Your point is?
> > 
> > It may very well be unintentional access, especially when taking into
> > account wildcards in profiles and user-writable directories.
> 
> Again, you're saying that AA is not confining unconfined processes.
> That's a given. If unconfined processes assist confined processes in
> breeching their confinement, yes, that is not mediated.

The issue arises even for a collection of collaborating confined
processes with different profiles, and the collaboration may be
intentional or unintentional (in the latter case, one of the confined
processes may be taking advantage of known behavior of another process
and shared access by both to some resource in order to induce a
particular behavior in that process).

And remember that confinement isn't just about limiting untrusted
processes but also about protecting trusted processes; limiting the
inputs and outputs of a trusted process can be just as important to
preventing exploitation.

> You're basically saying that anything but system-wide mandatory access
> control is pointless.

Mandatory access control as historically understood has always meant
system-wide.  As well as always being based on the security properties
of the data (so that global and persistent protection of the data is
possible).  You can't actually use the terms 'mandatory access control'
or 'confinement' for AppArmor unless you redefine them.

> If you want to go down that route, what is your reply to me saying that
> SELinux cannot mediate NFS mounts - if the server is not confined using
> SELinux as well? The argument is really, really moot and pointless. Yes,
> unconfined actions can affect confined processes. 

Sorry, do you mean the "server" as in the "server system" or as in the
"server daemon"?  For the former, I'd agree - we would want SELinux
policy applied on the server as well as the client to ensure that the
data is being protected consistently throughout and that the server is
not misrepresenting the security guarantees expected by the clients.
Providing an illusion of confinement on each client without any
corresponding protection on the server system would be very prone to
bypass.  For the latter, the kernel can only truly confine application
code, not in-kernel threads, although we can subject the in-kernel nfsd
to permission checking as a robustness check.  We've always noted that
SELinux does depend on the correctness of the kernel.

> > > That is an interesting argument, but not what we're discussing here.
> > > We're arguing filesystem access mediation.
> > IOW, anything that AA cannot protect against is "out of scope".  An easy
> > escape from any criticism.
> 
> I'm quite sure that this reply is not AA specific as you try to make it
> appear.

Every time we've noted an issue with AA, the answer has been that it is
out of scope.  Yet the public documentation for AA misrepresents the
situation and its comparisons with SELinux conveniently ignore its
limitations.

> > > Yes. Your use case is different than mine.
> > My use case is being able to protect data reliably.  Yours?
> 
> I want to restrict certain possibly untrusted applications and
> network-facing services from accessing certain file patterns, because as
> a user and admin, that's the mindset I'm used to. I might be interested
> in mediating other channels too, but the files are what I really care
> about. I'm inclined to trust the other processes.
> 
> Your use case mandates complete system-wide mediation, because you want
> full data flow analysis. Mine doesn't.

Then yours isn't mandatory access control, nor is it confinement.  

-- 
Stephen Smalley
National Security Agency

