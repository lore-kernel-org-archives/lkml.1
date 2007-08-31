Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXHaJBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXHaJBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbXHaJBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:01:02 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:37775 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758206AbXHaJBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:01:00 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 05:00:59 EDT
X-YMail-OSG: N08h8uYVM1le8hRKhPSMcJQ7LlxIk597cAUwXkWN17k46mUMaWvncAIKtjvZTHrk4vuU6zOrHC4_SMnwTRBPtPOucA--
X-RocketYMMF: knobi.rm
Date: Fri, 31 Aug 2007 01:54:19 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Reply-To: knobi@knobisoft.de
Subject: Re: recent nfs change causes autofs regression
To: Ian Kent <raven@themaw.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>, akpm@linux-foundation.org,
       Ion Badulescu <ionut@badula.org>, Linus@yahoo.com
In-Reply-To: <Pine.LNX.4.64.0708311317260.8223@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <431847.79962.qm@web32602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Ian Kent <raven@themaw.net> wrote:

> On Thu, 30 Aug 2007, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 31 Aug 2007, Trond Myklebust wrote:
> > > 
> > > It did not. The previous behaviour was to always silently
> override the
> > > user mount options.
> > 
> > ..so it still worked for any sane setup, at least.
> > 
> > You broke that. Hua gave good reasons for why he cannot use the
> current 
> > kernel. It's a regression.
> > 
> > In other words, the new behaviour is *worse* than the behaviour you
> 
> > consider to be the incorrect one.
> > 
> 
> This all came about due to complains about not being able to mount
> the 
> same server file system with different options, most commonly ro vs.
> rw 
> which I think was due to the shared super block changes some time
> ago. 
> And, to some extent, I have to plead guilty for not complaining
> enough 
> about this default in the beginning, which is basically unacceptable
> for 
> sure.
> 
> We have seen breakage in Fedora with the introduction of the patches
> and 
> this is typical of it. It also breaks amd and admins have no way of 
> altering this that I'm aware of (help us here Ion).
> 
> I understand Tronds concerns but the fact remains that other Unixs
> allow 
> this behaviour but don't assert cache coherancy and many sysadmin
> don't 
> realize this. So the broken behavior is expected to work and we can't
> 
> simply stop allowing it unless we want to attend a public hanging
> with us 
> as the paticipants.
> 
> There is no question that the new behavior is worse and this change
> is 
> unacceptable as a solution to the original problem.
> 
> I really think that reversing the default, as has been suggested, 
> documenting the risk in the mount.nfs man page and perhaps issuing a 
> warning from the kernel is a better way to handle this. At least we
> will 
> be doing more to raise public awareness of the issue than others.
> 

 I can only second that. Changing the default behavior in this way is
really bad.

 Not that I am disagreeing with the technical reasons, but the change
breaks working setups. And -EBUSY is not very helpful as a message
here. It does not matter that the user tools may handle the breakage
incorrect. The users (admins) had workings setups for years. And they
were obviously working "good enough".

 And one should not forget that there will be a considerable time until
"nosharecache" will trickle down into distributions.

 If the situation stays this way, quite a few people will not be able
to move beyond 2.6.22 for some time. E.g. for I am working for a
company that operates some linux "clusters" at a few german automotive
cdompanies. For certain reasons everything there is based on
automounter maps (both autofs and amd style). We have almost zero
influence on that setup. The maps are a mess - we will run into the
sharecache problem. At the same time I am trying to fight the notorious
"system turns into frozen molassis on moderate I/O load". There maybe
some interesting developements coming forth after 2.6.22. Not good :-(

 What I would like to see done for the at hand situation is:

- make "nosharecache" the default for the forseeable future
- log any attempt to mount option-inconsistent NFS filesystems to dmesh
and syslog (apparently the NFS client is able to detect them :-). Do
this regardless of the "nosharecache" option. This way admins will at
least be made aware of the situation.
- In a year or so we can talk about making the default safe. With
proper advertising.

 Just my € 0.02.

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
