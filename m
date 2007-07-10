Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbXGJRbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbXGJRbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbXGJRa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:30:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbXGJRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:30:58 -0400
Message-ID: <4693C0A1.8010901@zytor.com>
Date: Tue, 10 Jul 2007 10:23:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>
In-Reply-To: <4693BF02.2050705@gentoo.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> H. Peter Anvin wrote:
>> User error.
>> Please replace user and press any key.
>>
>> # CONFIG_FIRMWARE_EDID is not set
>>
>> The user has *explicitly* disabled acquisition of EDID from the
>> firmware, so of course it doesn't probe for it.
> 
> I'm not versed with all this EDID and resolution stuff, but shouldn't
> the resolution be detected correctly under all configurations?

Not if you actively disable detection!

Why would you want to be able to disable detection?  Well, your BIOS
might be buggy.

> The original problem is that as of 2.6.20.11, the resolution is
> misdetected - it is wrong by 6 pixels. The same configuration with
> 2.6.20.10 works fine.

That is because 2.6.20.11 incorrectly disabled EDID detection when a
non-VESA mode was chosen as the initial mode.  This is a bug.

> With the 2.6.20.10/2.6.20.11 configuration, the user did have
> CONFIG_FIRMWARE_EDID set. I'm not sure why he changed this for the -mm
> testing, but then again I don't understand why it should matter.

You're complaining that we didn't query EDID when you *explicitly* asked
us not to.  This is not a bug!

	-hpa
