Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbXFVMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbXFVMz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXFVMzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:55:46 -0400
Received: from gate.in-addr.de ([212.8.193.158]:52876 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbXFVMzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:55:44 -0400
Date: Fri, 22 Jun 2007 14:54:57 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622125457.GS20105@marowsky-bree.de>
References: <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070621211743.GN20105@marowsky-bree.de> <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil> <20070622113727.GJ20105@marowsky-bree.de> <1182516111.24664.72.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1182516111.24664.72.camel@moss-spartans.epoch.ncsc.mil>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-22T08:41:51, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> The issue arises even for a collection of collaborating confined
> processes with different profiles, and the collaboration may be
> intentional or unintentional (in the latter case, one of the confined
> processes may be taking advantage of known behavior of another process
> and shared access by both to some resource in order to induce a
> particular behavior in that process).

Point taken; the point remains is that you need at least several
(intentionally or not) cooperating processes. The chances of this are
significantly lower than a single process exploit.

> And remember that confinement isn't just about limiting untrusted
> processes but also about protecting trusted processes; limiting the
> inputs and outputs of a trusted process can be just as important to
> preventing exploitation.

True. It'd appear that if you want that, you'd specify the AA profile so
that it doesn't include directories/files writable by untrusted
processes.

> Sorry, do you mean the "server" as in the "server system" or as in the
> "server daemon"?  For the former, I'd agree - we would want SELinux
> policy applied on the server as well as the client to ensure that the
> data is being protected consistently throughout and that the server is
> not misrepresenting the security guarantees expected by the clients.
> Providing an illusion of confinement on each client without any
> corresponding protection on the server system would be very prone to
> bypass.  For the latter, the kernel can only truly confine application
> code, not in-kernel threads, although we can subject the in-kernel nfsd
> to permission checking as a robustness check.  We've always noted that
> SELinux does depend on the correctness of the kernel.

Oh, you're saying that this threat is out-of-scope? ;-)

> Every time we've noted an issue with AA, the answer has been that it is
> out of scope.  Yet the public documentation for AA misrepresents the
> situation and its comparisons with SELinux conveniently ignore its
> limitations.

I'm sorry. Again, I'm not responsible for marketing comparisons made by
anyone else, nor do I think they should apply to this discussion where
we're discussing the merits of what AA actually _does_; not what
someone's marketing claims it does - otherwise I'll go dig out marketing
claims about SELinux too ;-)

And, coming at it from that direction, I feel it does something useful.

Note that here we've already strayed from the focus of the discussion;
we're no longer arguing "the implementation is ugly/broken", but you're
claiming "doesn't do what I need" - which I'm not disagreeing with. It
doesn't do what you want. Which is why you have SELinux, and it's going
to stay. Fine.

If we assume that the users who run it do have a need / use case for it
which they can't solve differently, we should really get back to the
discussion of how those needs can be met or provided by Linux in a
feasible way.

> > Your use case mandates complete system-wide mediation, because you want
> > full data flow analysis. Mine doesn't.
> Then yours isn't mandatory access control, nor is it confinement.  

I apologize for not using the word "confinement" in the way you expect
it to be used. I certainly don't want to imply it does do things it
doesn't. Keep in mind I'm not a native speaker, so nuances do get lost
sometimes; nor do I have long years of experience in the security
field. Thanks for clearing this up.

So agreed, it is not confinement nor MAC.

Would it be more appropriate if I used the word "restricts" or
"constrains"?


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

