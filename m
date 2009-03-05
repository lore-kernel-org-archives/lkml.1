Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZCEMWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZCEMWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZCEMWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:22:12 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:31498
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752252AbZCEMWK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:22:10 -0500
X-BigFish: VPS-45(zz1454M1432R98dR168aJ936eQ1805M1442J936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KG190N-01-90B-01
Date: Thu, 5 Mar 2009 13:21:57 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: msr architecture debug code
Message-ID: <20090305122157.GA7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <1236194183.4994.9.camel@localhost.localdomain> <1236199796.3130.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1236199796.3130.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Mar 2009 12:22:00.0374 (UTC) FILETIME=[FBE37560:01C99D8C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 02:19:56AM +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-05 at 00:46 +0530, Jaswinder Singh Rajput wrote:
> 
> > The following changes since commit 1d10914bf2c8a1164aef6c341e6c3518a91b8374:
> >   Ingo Molnar (1):
> >         Merge branch 'core/percpu'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> > 
> > Jaswinder Singh Rajput (1):
> >       x86: msr architecture debug code

Hi,

Why do we need this in-kernel?
We have already access to MSRs via /dev/cpu/*/msr

Did you have a look at x86info.  (see
http://www.codemonkey.org.uk/projects/x86info/)
Recent versions contain a tool called lsmsr -- which shows you MSRs
and also decodes some bits, e.g.

# lsmsr IntPendingMessage -V 3 -c 1
IntPendingMessage    = 0x00000000082100b0
  IOMsgAddr=0xb0
  IOMsgData=0x21
  IntrPndMsgDis=0
  IntrPndMsg=0
  IORd=0
  SmiOnCmpHalt=0x1
  C1eOnCmpHalt=0

The tool just lacks some detailed MSR definitions for non-AMD CPUs.
Feel free to add them ... (and to fix bugs if encountered ;-)

Of course I've applied your patch to do a sniff test and found the
following:

- I've just one directory in debugfs
  x86/cpu/msr/cpu0
  The system has a quad-core CPU. So I guess there should be 4
  directories -- one for each core.

- The file showing MTRRs is misspelled (mttr instead of mtrr).


Regards,
Andreas


-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


