Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZKPRuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZKPRuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:50:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZKPRuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:50:01 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35441 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbZKPRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:50:00 -0500
Date: Mon, 16 Nov 2009 12:50:06 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca>
References: <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca> <20091112121805.GF1394@ucw.cz> <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca> <20091113165730.0b9b2676@lxorguk.ukuu.org.uk> <20091113192412.GY15157@caffeine.csclub.uwaterloo.ca> <20091113212148.5cb829d4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113212148.5cb829d4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 09:21:48PM +0000, Alan Cox wrote:
> > > Which usually means some form of write gathering is enabled or something
> > > thinks the device is write combining on the PCI bus. What does the PCI
> > > bus and the RCRR MTRR set look like ?
> > 
> > Well there is no /proc/mtrr.
> 
> Linux doesn't have an RCRR driver - so you need to dump the MSRs directly
> (see the Geode GX manual MSR list) and read out the msrs.

Hmm, so looking at the Geode SC1200 data book, it doesn't mention mtrr,
rcrr or msr.  I know the Geode LX has lots of MSR documentation.

Looking at the GX1 data book (which it seems the SC1200 refers to),
it does mention mtrr, as not supported.  I have managed to find something
called the region configuration range registers, which must be RCRR.

I think this is a dump of the 8 region MSRs:

0x00001810->0xbf848ba8b7f282e8
0x00001811->0xbfcb5328b7f932e8
0x00001812->0xbfe93418b7f712e8
0x00001813->0xbfbd59b8b7fb52e8
0x00001814->0xbfb5f868b7f3d2e8
0x00001815->0xbf815018b7ef42e8
0x00001816->0xbfc4c0d8b7f2a2e8
0x00001817->0xbfe1eea8b7eff2e8

This must of course mean I read them wrong because those are not the
right values.  Some bit ranges must be 0 and are not.

Trying rdmsr from msr-tools 1.2 gives me:

# ./rdmsr -x 0x00001810
rdmsr: CPU 0 cannot read MSR 0x00001810

Hmm, now what?

-- 
Len Sorensen
