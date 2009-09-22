Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZIVXnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZIVXnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZIVXnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:43:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54458 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZIVXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:43:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 22 Sep 2009 16:43:17 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jamie Lokier <jamie@shareable.org>
cc: Eric Paris <eparis@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org
Subject: Re: fanotify as syscalls
In-Reply-To: <20090922162707.GA11608@shareable.org>
Message-ID: <alpine.DEB.2.00.0909221139570.12001@makko.or.mcafeemobile.com>
References: <20090912094110.GB24709@ioremap.net> <20090921231227.GJ14700@shareable.org> <alpine.DEB.2.00.0909211816020.1116@makko.or.mcafeemobile.com> <200909221731.34717.agruen@suse.de> <1253635918.2747.5.camel@dhcp231-106.rdu.redhat.com>
 <20090922162707.GA11608@shareable.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Jamie Lokier wrote:

> Eric Paris wrote:
> > That's not the fatal flaw.  The fatal flaw is that I am not going to
> > write 90% of a rootkit and make it easy to use.
> 
> I hate to point out the obvious, but fanotify's ability to intercept
> every file access and rewrite the file before the access proceeds is
> also 90% of a rootkit...

Obvious, but worth noticing.
Indeed, the syscall table has been RO to make it harder for RKs to 
exploit it, not to make it impossible. RO syscall table makes perfect 
sense.
But, once you are root, with very few lines of code, you can find, 
prot-fix the page, and patch the table.



> But fortunately both fanotify and syscall rewriting require root in
> the first place.                          ^^^^^^^^^

Again, maybe I wasn't clear about how this would work, but the syscall 
table would continue to remain RO ;)
And as I said before, if we want to bring the cost of the interception for 
non-users pretty close to zero (a few NOPs to run onto), we could even 
adopt an alternative-like patching triggered by a kernel boot option.



- Davide


