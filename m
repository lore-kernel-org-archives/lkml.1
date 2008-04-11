Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYDKP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYDKP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759691AbYDKP1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:27:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42897 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943AbYDKP1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:27:10 -0400
Date: Fri, 11 Apr 2008 16:26:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080411152648.GK9785@ZenIV.linux.org.uk>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411081901.f56f5180.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:19:01AM -0700, Randy Dunlap wrote:

> > It
> > is a totally uninteresting warning that we pass in a narrower type to 
> > printk(). It cannot ever cause any bugs or problems. Why does gcc warn 
> > about it?
> 
> No idea about that part.

Er...  That's kinda obvious - vararg function getting the wrong-sized
argument is *NOT* a harmless situation.  And yes, it's certainly a bug -
gcc manages to recover by using the knowledge of printf() formats (i.e.
it guesses that we want a long long and does conversion), but try to
do
	char *s = "%llx %c";
	printf(s, 1, '.');
and watch the show...
