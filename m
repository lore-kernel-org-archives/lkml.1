Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbXFJGgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbXFJGgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 02:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXFJGf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 02:35:58 -0400
Received: from main.gmane.org ([80.91.229.2]:43098 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbXFJGf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 02:35:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kari Hurtta <hurtta+gmane@siilo.fmi.fi>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Date: 10 Jun 2007 09:35:41 +0300
Message-ID: <5dr6okgvuq.fsf@Hurtta06k.keh.iki.fi>
References: <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org> <20070610031922.GC21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706092036500.20321@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cs130027.pp.htv.fi
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes in gmane.linux.kernel:

<...>
> But let's say that you want to do a library that does name resolution, and 
> you actually want to create the socket that binds to the DNS server just 
> once, and then re-use that socket across library calls. It's not that the 
> library is a thread of its own - it's not - but with the normal linear fd 
> space it really cannot do this. Sure, it could try to hide it up somewhere 
> in high fd space, but that would slow down other operations, and there's 
> no way to guarantee it doesn't clash with some _other_ library doing the 
> same thing, so it really isn't a good idea.
> 
> Now, when you do a DNS query, the setup cost of opening the socket is the 
> least of your worries, so the above example is not a very good one. I'm 
> really just giving it as a concrete example of a _conceptual_ problem, 
> where some other library really had more pressing performance reasons why 
> they cannot keep re-opening a file descriptor and closing it each time.
> 
> So _that_ is the kind of situation where I think "anonymous file 
> descriptors" make sense. 
> 
> 		Linus

Real world example is nss_ldap / pam_ldap -- these needs open socket to 
ldap server.  That socket is cached. And because they can not trust that 
application does not have closed file description of them, they check it with 
getpeername + getsockname  (at least it did when I looked code on
some years ago.)   

( opening socket again includes using starttls and  authentication  .. so it is 
  quite some overhead )

/ Kari Hurtta

