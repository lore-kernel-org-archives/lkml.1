Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbXEWW3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbXEWW3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXEWW3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:29:11 -0400
Received: from outbound-mail-55.bluehost.com ([69.89.20.35]:44337 "HELO
	outbound-mail-55.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756306AbXEWW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:29:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 15:28:54 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231506.36229.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231528.56064.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 3:16 pm Linus Torvalds wrote:
> On Wed, 23 May 2007, Jesse Barnes wrote:
> > > How are those boards going to set up mmconfig? The whole standard
> > > is broken, since there is no way to set it up.
> > >
> > > Trust the firmware? What a piece of crap!
> >
> > What do you mean?  You set it up the normal way, by poking at
> > config space to see what's there
>
> HOW DO YOU GET TO THE CONFIG SPACE IN THE FIRST PLACE?
>
> The reason mmconfig is *BROKEN*CRAP* is that you cannot bootstrap it.
> There's no standard way to even figure out WHERE IT IS!
>
> So we depend on firmware tables that are known to be broken!
>
> That crap should be seen for the crap it is! Dammit, how hard can it
> be to just admit that mmconfig isn't that great?

Ah, yeah, that's platform specific, I thought you were confused about 
how the sizing worked.  On x86, we either have to look at ACPI tables 
(yay) or use type 1 config accesses to get at the mmconfig base 
register (which is what the patches Olivier and I posted do).  On ia64 
there are firmware calls to do config space accesses.  Not sure about 
other platforms.

I'm not claiming mmconfig is great and we should make everything use it, 
but we do need it these days, so we should figure out a good way of 
getting at it.

Jesse
