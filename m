Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbXFUTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbXFUTY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXFUTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:24:47 -0400
Received: from gate.in-addr.de ([212.8.193.158]:48006 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbXFUTYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:24:45 -0400
Date: Thu, 21 Jun 2007 21:24:07 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621192407.GF20105@marowsky-bree.de>
References: <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070621183311.GC18990@elf.ucw.cz>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-21T20:33:11, Pavel Machek <pavel@ucw.cz> wrote:

> inconvenient, yes, insecure, no.

Well, only if you use the most restrictive permissions. And then you'll
suddenly hit failure cases which you didn't expect to, which can
possibly cause another exploit to become visible.

> I believe AA breaks POSIX, already. rename() is not expected to change
> permissions on target, nor is link link. And yes, both of these make
> AA insecure.

AA is supposed to allow valid access patterns, so for non-buggy apps +
policies, the rename will be fine and does not change the (observed)
permissions.

The time window in the rename+relabel approach however introduces a slot
where permissions are not consistent. This is a different case.

> > You _must_ be kidding. The cure is worse than the problem.
> Possibly.

Yes.

> > If that is the only way to implement AA on top of SELinux - and so far,
> > noone has made a better suggestion - I'm convinced that AA has technical
> > merit: it does something the on-disk label based approach cannot handle,
> > and for which there is demand.
> What demand? SELinux is superior to AA, and there was very little
> demand for AA. Compare demand for reiser4 or suspend2 with demand for
> AA.

SELinux is superior to AA for a certain scenario of use cases; as we can
see here, it is not superior to AA for _all_ use cases.

> > The code has improved, and continues to improve, to meet all the coding
> > style feedback except the bits which are essential to AA's function
> Which are exactly the bits Christoph Hellwig and Al Viro
> vetoed. http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.1/2587.html
> . I believe it takes more than "2 users want it" to overcome veto of
> VFS maintainer.

A veto is not a technical argument. All technical arguments (except for
"path name is ugly, yuk yuk!") have been addressed, have they not?



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

