Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbXINOJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbXINOJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXINOI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:08:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbXINOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:08:56 -0400
Message-ID: <46EA95E1.4000308@zytor.com>
Date: Fri, 14 Sep 2007 07:08:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andreas Herrmann <aherrman@arcor.de>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       dean gaudet <dean@arctic.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
References: <46E9A391.3000804@zytor.com> <20070914082129.GA6727@devil> <20070914112154.GB6727@devil>
In-Reply-To: <20070914112154.GB6727@devil>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
>>>
>> I'm not talking about Linux here.  I'm talking about any random system
>> software (which may or may not be Vista, and may nor may not even be an
>> OS.)
> 
> Are you serious? You are worried about Vista compatibility issues for
> new hardware? Here on LKML? I thought this is a Linux mailing list.
> 

No, I'm not concerned about Vista.  Read: MAY OR MAY NOT EVEN BE AN OS.
 In fact, non-OS system software, such as bootloaders or diagnostic
systems, are in fact much more difficult in this than OSes.

>>  If they advertise MCFG, then a random OS could try to use it, in
>> accordance with the spec, without the workaround, with serious
>> malfunction as a result.
> 
> Have you looked into the BKDG of that CPU?
> You can download it here
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116.pdf
> 
> BTW, in this version it is even recommended to set up MCFG. So why should a
> BIOS vendor drop it?

They probably won't, which is highly unfortunate.  AMD is unlikely to
admit that they have a serious bug in their compliance, and BIOS vendors
are unlikely to catch on.  It's still broken.

> Because I am not as standards-compliant as you are, I should say: "To err is human".
> So I've done my best to verify that config space stuff with real code on real hardware
> last week. But as always, it is possible that I am wrong with certain statements.

To err is human (and, in silicon manufacturing, both common and
extremely expensive.)  It's now you deal with the fallout that matters,
and it's quite unforgiving, because we're dealing with computer
protocols here.  You MUST NOT advertise compliance with a protocol that
you don't actually have (MCFG).  You then SHOULD promulgate workarounds
that say "oh, I'm on chip X, that means that I can enable mmconfig as
long as I play within these chip-specific rules."

> Do you think it is a good idea to discuss that MMCONFIG topic with
> some designers at AMD? I could print out that mail or forward it to them.
> Do you think they will be happy to listen to your words if you say that
> they are "fucking up" stuff and come up with "braindamaged" ideas?
> I appreciate the code you write, but not the communication style you chose.

Uhm, it's hardware.  Bugs happen.  What gets ugly is when marketing gets
involved, and says "we can't afford to say we don't have <feature X>, so
let's advertise it anyway."

	-hpa

