Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYKFKEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYKFKEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYKFKE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:04:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYKFKE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:04:27 -0500
Date: Thu, 6 Nov 2008 11:04:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Koyama, Yoshiya" <Yoshiya.Koyama@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081106100410.GN4890@elte.hu>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com> <20081104151234.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104151234.GH28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> > On Sun, Oct 26, 2008 at 10:08 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > # uname -a
> > Linux localhost.localdomain 2.6.25.11-97.fc9.i686 #1 SMP Mon Jul 21
> > 01:31:09 EDT 2008 i686 i686 i386 GNU/Linux
> > # prelink -mRf /sbin/udevd
> > # ./a.out /proc/564/exe
> > warning: /proc/564/exe: got return value 38, expected 11
> > 2f7362696e2f7564657664005f47387942426e5952446e566f306868202864656c6574656429
> > /sbin/udevd _G8yBBnYRDnVo0hh (deleted)
> > 
> > Yoshiya Koyama reports that the problem exists on RHEL 2.6.9-42.ELsmp too.
> > 
> > I don't think it's exactly the same problem as originally reported,
> > because I definitely wasn't using prelinking (the prelink binary
> > wasn't even installed on the machine until today). But finding the
> > root cause of this may solve both problems.
> 
> switch_names() buggered in case of short names on both sides.  That should
> help:
> 
> >From 2acda856910b774717e0290bbf948c7dee0f2e1a Mon Sep 17 00:00:00 2001
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Mon, 3 Nov 2008 15:03:50 -0500
> Subject: [PATCH] fix switch_names() breakage in short-to-short case
> 
> We want ->name.len to match the resulting name on *both*
> source and target
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

please credit kmemcheck in the commit message and use an appropriate 
Reported-by line as well. Thanks,

	Ingo
