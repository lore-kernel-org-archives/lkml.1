Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYAXW7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYAXW7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYAXW7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:59:30 -0500
Received: from gw.goop.org ([64.81.55.164]:35621 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbYAXW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:59:29 -0500
Message-ID: <47991809.9060903@goop.org>
Date: Thu, 24 Jan 2008 14:58:17 -0800
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
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com>	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>	 <1201121530.30671.15.camel@cthulhu.hellion.org.uk>	 <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org> <479913BA.8000506@zytor.com>
In-Reply-To: <479913BA.8000506@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yeah, and it's ugly for the kernel proper, so that bit is a 
> no-brainer.  It's just a matter of hammering out the details.
>
> It doesn't sound from the above that you have any opinion either way 
> about reusing the initial page tables or creating a new set, as long 
> as they're in the same format. 

Right.

Xen provides a initial set of pagetables in the appropriate format, so 
what head.S generates is moot.  For simplicity I graft the Xen-provided 
pagetables into swapper_pg_dir in xen_start_kernel, so it is the 
functional equivalent to the head.S pagetable construction.

We also don't (yet) support PSE, so that's a non-issue for us too.

    J
