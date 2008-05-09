Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYEIGaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYEIGaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYEIG34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:29:56 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:57246 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753022AbYEIG3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:29:55 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regression fixed by using pci=rom
Date: Thu, 8 May 2008 23:29:39 -0700
User-Agent: KMail/1.9.9
Cc: Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com> <200805081717.54102.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082329.39987.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2008 6:46 pm Linus Torvalds wrote:
> On Thu, 8 May 2008, Jesse Barnes wrote:
> > Hm, yeah in many cases we definitely *do* want to try to get the
> > expansion ROM space allocated.  But maybe it should be a lower priority
> > than other BARs... Gary?
>
> The thing is, a lot of these things have been done this way because not
> doing them that way breaks.
>
> We want to allocate expansion ROM space - even if we don't enable it -
> because not doing so will screw up bus sizing etc, and can make it
> impossible to allocate later.
>
> In general, changing PCI allocation strategy is really _really_ dangerous,
> even when it is "right", because it tends to expose a lot of issues where
> something worked just because it was perhaps indirectly causing a layout
> that worked.

Yeah, that was my first impression too, but the patch went upstream awhile ago 
and I didn't see any background except for the changelog.

If anything, we should have a pci=norom option instead, so that big systems 
that don't need the ROMs can use their address space more efficiently.

Jesse
