Return-Path: <linux-kernel-owner+w=401wt.eu-S1758355AbXEWXWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbXEWXWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXEWXWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:22:11 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:34570 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756160AbXEWXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:22:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 16:21:48 -0700
User-Agent: KMail/1.9.6
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       galibert@pobox.com, linux-kernel@vger.kernel.org, ak@suse.de,
       cebbert@redhat.com, lenb@kernel.org
References: <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org> <200705231611.18944.jbarnes@virtuousgeek.org> <4654CB1E.3070409@shaw.ca>
In-Reply-To: <4654CB1E.3070409@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231621.48564.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 4:15 pm Robert Hancock wrote:
> Jesse Barnes wrote:
> > On Wednesday, May 23, 2007 4:04 pm David Miller wrote:
> >> From: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date: Wed, 23 May 2007 15:16:23 -0700 (PDT)
> >>
> >>> That crap should be seen for the crap it is! Dammit, how hard can
> >>> it be to just admit that mmconfig isn't that great?
> >>
> >> I knew mmconfig was broken conceptually the first time I started
> >> seeing write posting "bug fixes" for it that would do a read back
> >> from PCI config space via mmconfig to post the write, which of
> >> course has potential side-effects on the device and is absolutely
> >> illegal if the write just performed put the device into a PM state
> >> or whatever.
> >
> > I've actually seen that specific form of posted write flushing
> > cause crashes on some machines, so yes, it sucks.
> >
> > Unfortunately, I don't think we have any other way of getting at
> > extended config space on x86, unless EFI provides methods or
> > something, but I'm not sure that would be an improvement...
>
> That "fix" shouldn't be needed at all, the MMCONFIG memory range
> shouldn't be covered by PCI ordering rules, so there should be no
> such thing as write posting. I suspect that the author of such
> patch(es) was doing so out of some misguided sense that it was
> needed. (And if there is some chipset where it is actually needed,
> better just disable MMCONFIG on that one, as there's no way to use it
> sanely.)

PCI allows write posting, and on systems using mmconfig the posting 
generally (unfortunately) extends to that space as well.  So drivers 
need to deal with it somehow.  But many get it wrong.

Jesse
