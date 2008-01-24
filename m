Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYAXWfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYAXWfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYAXWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:35:33 -0500
Received: from gw.goop.org ([64.81.55.164]:53130 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994AbYAXWfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:35:31 -0500
Message-ID: <479912B0.2080506@goop.org>
Date: Thu, 24 Jan 2008 14:35:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com>	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>	 <1201121530.30671.15.camel@cthulhu.hellion.org.uk>	 <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com>
In-Reply-To: <47990BDC.4070008@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> In other words, reusing the early page tables isn't all that 
> straightforward.  It may easily be that it's better to build a new set 
> of page tables from scratch, however, it would *still* be beneficial 
> to have the early page tables be in the same format as the later one, 
> since it lets us use the fixmap area, and therefore 
> {bt,early}_ioremap() much sooner.

Yes, and it simplifies Xen as it always starts guest domains in the 
appropriate pagetable mode and doesn't let the guest change it on the 
fly.  If early_ioremap depends on non-PAE early pagetables in an 
otherwise PAE kernel, we'd need to go to some effort to make sure all 
the early_ioremap stuff is skipped (which would be possible but 
unpleasant for domU, but very bad in dom0).

    J

