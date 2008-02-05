Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYBEQiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYBEQiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYBEQiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:38:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbYBEQiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:38:10 -0500
Date: Tue, 5 Feb 2008 17:37:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jakub Jelinek <jakub@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Re: brk randomization breaks columns
Message-ID: <20080205163724.GA31286@elte.hu>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205110632.GB3758@elf.ucw.cz> <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz> <20080205125426.GA27724@elte.hu> <20080205130546.GF30691@devserv.devel.redhat.com> <20080205161810.GF24331@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205161810.GF24331@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > > > I am still not completely sure. It might be a regression, but it 
> > > > also might just trigger the bug in ancient version in libc.so.5 
> > > > which might be fixed in some later version [...]
> > > 
> > > which too is a regression ...
> > > 
> > > really, lets add a sysctl for this, and a .config option that 
> > > either disables or enables it. Then we will default to disabled. 
> > > (but users can enable it - and distros can build their kernels 
> > > with this .config option enabled)
> > 
> > I don't think kernel should care about programs which are buggy and 
> > make invalid assumptions, and that's the case here.  I remember we 
> > have been
> 
> Those "invalid assumptions" crept into documentation. Everybody knew 
> heap starts at the end of bss in 1995.

what matters most isnt really any documentation but what programs really 
do, and how it affects users.

in this case i think we should offer a .config option to set the 
randomization behavior, and should perhaps make the more conservative 
one the default.

New distros (with 10,000+ binaries that work just fine with 
randomization) will turn on max randomization by default, while people 
like you who mix 1996 binaries with a 2008 kernel will use a more 
conservative default.

	Ingo
