Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZISOIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZISOIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 10:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZISOI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 10:08:29 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41411
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753647AbZISOI3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 10:08:29 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1432R1453M98dNzz1202hzz5eeeTz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ81XV-04-9F9-02
X-M-MSG: 
Date: Sat, 19 Sep 2009 16:08:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Keith Mannthey <kmannth@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
Message-ID: <20090919140821.GA29261@aftab>
References: <1253239781.7263.113.camel@keith-laptop>
 <20090918144226.GD25309@aftab>
 <1253294933.7263.129.camel@keith-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253294933.7263.129.camel@keith-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Sep 2009 14:08:18.0538 (UTC) FILETIME=[A35C8CA0:01CA3932]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 10:28:53AM -0700, Keith Mannthey wrote:
> > Almost. You have 8 DCSMs on RevE, 4 on RevF and F10h and 2 on F11h and
> > this way you get wrong DCSM offsets for F11h. A dirty fix would be:
> 
> I think this will still be ok for F11. 
> 
> 
> ilog2(2) = 1 
> 
> 1 + 1 == 2 
> 
> 8 >> 2 == 2 
> 
> csrow >> 2 
> 
> This would be ok rev F11 assuming 8 total. 
> 
> Am I missing something else?

Yes, F11h has only 4 DCSB and 2 DCSM registers. So the first
two DCSB registers F2x[1,0]40 and F2x[1,0]44 use F2x[1,0]60 as
a mask register and F2x[1,0]48 and F2x[1,0]4C use F2x[1,0]64.
You can look at F11h as a F10h but with only the half of the
DSC[BM] registers present. You can find the F11h BKDG at
http://support.amd.com/us/Processor_TechDocs/41256.pdf and especially
Table 24 on page 115.

So, in that case csrow >> 1 is still valid but csrow going beyond 3 is
out of range that's why it needs to be fixed differently.

> Are there more than 8 csrows any any version (I don't currently have
> F11 specs). Maybe should just move to a map rather than a math trick
> to get to the right index?

I'll think up something on Monday.

> > By the way, your patches made me look harder at that code region and
> > I've found some more problems with it which I've fixed. Would you
> > like to test the whole bunch of fixes on your setup?
>
> Yes please send any changes you have. I have a decent test setup for
> live errors.

Cool, I'll get back to you when I have them ready, thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

