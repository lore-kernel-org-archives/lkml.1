Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZIVPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZIVPcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZIVPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:32:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:58758 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZIVPcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:32:43 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: fanotify as syscalls
Date: Tue, 22 Sep 2009 17:31:34 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org
References: <20090912094110.GB24709@ioremap.net> <20090921231227.GJ14700@shareable.org> <alpine.DEB.2.00.0909211816020.1116@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0909211816020.1116@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221731.34717.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 September 2009 16:51:39 Davide Libenzi wrote:
> On Tue, 22 Sep 2009, Jamie Lokier wrote:
> > I don't mind at all if fanotify is replaced by a general purpose "take
> > over the system call table" solution ...
>
> That was not what I meant ;)
> You'd register/unregister as syscall interceptor, receiving syscall number
> and parameters, you'd be able to return status/error codes directly, and
> you'd have the ability to eventually change the parameters. All this
> should be pretty trivial code, and at the same time give full syscall
> visibility to the modules.

The fatal flaw of syscall interception is race conditions: you look up a 
pathname in your interception layer; then when you call into the proper 
syscall, the kernel again looks up the same pathname. There is no way to 
guarantee that you end up at the same object in both lookups. The security 
and fsnotify hooks are placed in the appropriate spots to avoid exactly that.

Andreas
