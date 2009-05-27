Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbZE0MKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbZE0MKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZE0MKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:10:39 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52289 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbZE0MKi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:10:38 -0400
From: Bela Lubkin <blubkin@vmware.com>
To: "'Ferenc Wagner'" <wferi@niif.hu>, Corey Minyard <minyard@acm.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 27 May 2009 05:10:39 -0700
Subject: RE: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
Thread-Topic: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
Thread-Index: AcnZ+WX+PXKAfWrdSMSE7Z5P2C/89AEyIVqA
Message-ID: <E0AA796A7E3F4C4E8F1065D15FE478610765E1A0@EXCH-MBX-4.vmware.com>
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
	<20090516170959.8057c9e4.akpm@linux-foundation.org>
	<877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
	<87iqjxzjz4.fsf@tac.ki.iif.hu> <4A1326C5.4010308@acm.org>
	<87ljoriwcw.fsf@tac.ki.iif.hu> <4A143103.9050302@acm.org>
 <878wkqpz2n.fsf@tac.ki.iif.hu>
In-Reply-To: <878wkqpz2n.fsf@tac.ki.iif.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver only behaves this way on systems where it has to.
If the BMC System Interface (SI) provides an interrupt, the
kernel thread doesn't run.  Everything is interrupt driven.

Anyone doing system software for x86 servers should be
harrassing the hardware vendors to get this right...

Interrupts can be used with any of the SIs (BT, KCS, SMIC),
but BT has the dual advantages of doing its transfers all at
once via DMA, and having a well defined interrupt mechanism.
Hardware designers implementing an interrupt for KCS or SMIC
have to guess at a few too many details.

Agitate for BT IPMI SI!

(HP's IPMI causes the least drag of any of the big vendors.
Although they use the same crummy char-by-char KCS SI [SMIC
on older systems], they always provide an IPMI interrupt.
I've heard that some modern Sun models use BT; haven't seen
it in action yet.)

>Bela<

> -----Original Message-----
> From: Ferenc Wagner [mailto:wferi@niif.hu] 
> Sent: Thursday, May 21, 2009 2:47 AM
> To: Corey Minyard
> Cc: Andrew Morton; openipmi-developer@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org
> Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs 
> under 2.6.30-rc5
> 
> Corey Minyard <minyard@acm.org> writes:
> 
> > Ferenc Wagner wrote:
> >
> >> Just out of interest, how often does the driver wake up to check
> >> the inteface?
> >
> > When idle, the driver wakes up every 10ms to check for something on
> > the driver.
> 
> Wow, 100 times per second, that sure sounds gross for piping out SEL
> entries!  Though it certainly doesn't matter much for our servers, but
> hasn't it got the potential to heavily tax laptop batteries?  Or is
> that why ipmi_si isn't loaded automatically by udev?
> -- 
> Thanks,
> Feri.
> 
> --------------------------------------------------------------
> ----------------
> Register Now for Creativity and Technology (CaT), June 3rd, NYC. CaT
> is a gathering of tech-side developers & brand creativity 
> professionals. Meet
> the minds behind Google Creative Lab, Visual Complexity, 
> Processing, & 
> iPhoneDevCamp asthey present alongside digital heavyweights 
> like Barbarian
> Group, R/GA, & Big Spaceship. http://www.creativitycat.com 
> _______________________________________________
> Openipmi-developer mailing list
> Openipmi-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/openipmi-developer
> 