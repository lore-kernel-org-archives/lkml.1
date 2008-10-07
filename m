Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYJGWbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYJGWbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYJGWbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:31:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYJGWbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:31:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: [Bug 10797] Battery is drained after poweroff
Date: Wed, 8 Oct 2008 00:35:18 +0200
User-Agent: KMail/1.9.9
Cc: "Pavel Machek" <pavel@suse.cz>, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       power-management_other@kernel-bugs.osdl.org
References: <20494.201.3.158.14.1223417777.mandic:mail - neo@webmail.mandic.com.br>
In-Reply-To: <20494.201.3.158.14.1223417777.mandic:mail - neo@webmail.mandic.com.br>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810080035.19040.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 of October 2008, Renato S. Yamane wrote:
> Kok, Auke wrote:
> > Pavel Machek wrote:
> >> Renato S. Yamane wrote:
> >>> Pavel Machek wrote:
> >>> Renato S. Yamane wrote:
> >>>>> Can someone help us with this bug?
> >>>>> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> >>>>>
> >>>>> Same problem is reported in Ubuntu:
> >>>>> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>
> >>>>>
> >>>>> This is not a hardware problem, because if the same laptop is poweroff
> >>>>> by Windows, battery charge don't change.
> >>>>
> >>>> ...and it is not linux problem because it works okay on my thinkpad. See?
> >>>
> >>> Yes, this is a Linux problem (at least in release >= 2.6.22)
> >>> This happening *only* in Linux (Kernel >=2.6.22).
> >>
> >> Wow, now that's useful info.
> 
> I don´t comment this before because we already said this in bug reports
> (links above).
> 
> >> I guess you _could_ do git bisect? ;-).
> 
> So sorry, but I really don´t now how can I do this.
> I´m an user, not developer. Can you send me a "how-to" about git bisect?

Seriously, this may be the fastest way to find out where the problem is.

It follows from your reports that the problem is present in 2.6.22, although
it wasn't present in 2.6.21.  If that's correct, you can do the following:
1) Clone the Linus' -git repository (if you have a copy already, you can use it)
2) Go to the directory containing your copy of the Linus' repo and do
	# git bisect start
	# git bisect good v2.6.21
	# git bisect bad v2.6.22
3) Wait for git to select a commit to test, build the kernel and test it.
   If it works correctly, do
	# git bisect good
   Otherwise, do
	# git bisect bad
4) Repeat 3) until you end up with single commit.

[Unfortunately this procedure may not converge for you (eg. you may encounter
a kernel version that won't compile etc.), but hopefully it will.  Then, you
will know which particular commit caused the problem to appear.]

5) When you're done, do
	# git bisect reset

Thanks,
Rafael
