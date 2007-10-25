Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbXJYBql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbXJYBql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXJYBqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:46:31 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45216
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbXJYBqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:46:30 -0400
Date: Wed, 24 Oct 2007 18:50:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Simon Arlott <simon@fire.lp0.eu>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to	static
 interface)
In-Reply-To: <20071024213704.GA2867@sergelap.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0710241847480.21140@asgard.lang.hm>
References: <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org>
 <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid>
 <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk>
 <Pine.LNX.4.64.0710242050540.17781@fbirervta.pbzchgretzou.qr>
 <471F9603.9080308@simon.arlott.org.uk> <Pine.LNX.4.64.0710242059500.17781@fbirervta.pbzchgretzou.qr>
 <1193259748.30930.91.camel@moss-terrapins.epoch.ncsc.mil>
 <20071024213704.GA2867@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Serge E. Hallyn wrote:

> The scariest thing to consider is programs which don't appropriately
> handle failure.  So I don't know, maybe the system runs a remote logger
> to which the multiadm policy gives some extra privs, but now the portac
> module prevents it from sending its data.  And maybe, since the authors
> never saw this failure as possible, the program happens to dump
> sensitive data in a public readable place.  I *could* be more vague but
> it'd be tough :)  But you get the idea.
>
> Or, a better example, a privileged program reads some sensitive data -
> as allowed by multiadm, writes it to a file, but apparmor prevented it
> from chowning the file to the right user before writing, the program
> kept writing anyway, and now the calling user hallyn, rather than the
> privileged user sensitive_log_t, owns the file.
>
> I ran into examples of this with the stacker module.  For instance
> suddenly the capability module had to be changed so that it would allow
> selinux xattrs to be written - leaving that arbitration to selinux.
> That hadn't been necessary before since selinux simply didn't explicitly
> call the secondary->inode_setxattr() hook.
>
> Note I'm not arguing for or against, only arguing for caution :)

this sort of problem is possible with just a single LSM.

remember that unix doesn't try to make it impossible for the system owner 
to hang himself, becouse there are many other cases where the rope is used 
productivly. don't let the possibility that things can be done wrong 
prevent other people from being creative in ways that you never thought 
of.

David Lang
