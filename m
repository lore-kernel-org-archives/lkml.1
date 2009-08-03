Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZHCBQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZHCBQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHCBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:16:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbZHCBQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:16:05 -0400
Date: Sun, 2 Aug 2009 18:14:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <4A7636DF.8090201@kernel.org>
Message-ID: <alpine.LFD.2.01.0908021811130.3352@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A7499BA.2000405@zytor.com>
 <alpine.LFD.2.01.0908011501470.3352@localhost.localdomain> <19060.59896.983880.446901@cargo.ozlabs.ibm.com> <4A750D66.6050203@zytor.com> <4A7636DF.8090201@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Aug 2009, Tejun Heo wrote:
> 
> Yeap, this part is strange.  I can't understand why it was done that
> way.  Interestingly, the segment override doesn't trigger any
> exception, it just gets ignored.  Is there a way to retrieve %gs value
> without accessing memory?  ie. other than %gs:identity_gs?

No. There's a "load segment limit" instruction, but not a base one. It's 
intentional - segments are supposed to be "anonymous" in protected mode 
(in real more of vm86 mode, the base is normally the segment register 
shifted left by four of course, but even that isn't _strictly_ always 
true).

You're very much not supposed to look at the base.

			Linus
