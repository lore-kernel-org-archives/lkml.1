Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYHHPWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYHHPWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYHHPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:21:58 -0400
Received: from gw.goop.org ([64.81.55.164]:54968 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbYHHPV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:21:57 -0400
Message-ID: <489C6485.7050009@goop.org>
Date: Fri, 08 Aug 2008 08:21:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Mark McLoughlin <markmc@redhat.com>, xen-devel@lists.xensource.com,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: Allow compile with CONFIG_DEBUG_INFO=y,	X86_PAE
 not set on gcc 3.4.5
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org> <20080808080155.GA1992@cs181140183.pp.htv.fi>
In-Reply-To: <20080808080155.GA1992@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> CONFIG_DEBUG_INFO=y is why I never hit it before.
>
> It does not seem to be just one dodgy Redhat compiler (as I assumed in 
> the Bugzilla entry) but the whole 3.4 series of gcc which makes our 
> resolution of saying that this specific compiler is broken invalid.
>
> Considering that we officially support all compilers >= 3.2 this is just 
> one more case where we have to add to the kernel a workaround for a 
> broken compiler.
>   

Yes.  I'm happy to write off a specific rpm package, but a whole series 
is a different matter.

Adding

	if (PREALLOCATED_PMDS == 0)
		return;

in the appropriate places with a small comment seems like the right answer.

    J
