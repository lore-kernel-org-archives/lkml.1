Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbYFKQNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbYFKQNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYFKQNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:13:40 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:13546 "EHLO
	mail81-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYFKQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:13:39 -0400
X-BigFish: VPS-38(zz1432R98dR7efV1805M3117Kzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2B3Q4-02-PFV-01
Date: Wed, 11 Jun 2008 18:12:34 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in pat_init()
Message-ID: <20080611161234.GC5889@alberich.amd.com>
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <20080611094130.GA5889@alberich.amd.com> <484FCC09.7020606@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484FCC09.7020606@keyaccess.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jun 2008 16:12:35.0741 (UTC) FILETIME=[F61DACD0:01C8CBDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 02:58:49PM +0200, Rene Herman wrote:
> On 11-06-08 11:41, Andreas Herrmann wrote:
>
>> As I had no Transmeta or Centaur CPU at hand I just cleared the PAT
>> flag in the CPU identification code to simulate the case that all CPUs
>> of a Vendor are whitelisted (even those w/o PAT support).  The first
>> time pat_init() is entered you get
>>   PAT enabled, but CPU feature cleared     (=> which is wrong as no flag 
>> was cleared)
>
> Again, you are misreading this. Please just replace the message mentally by 
> "PAT enabled, but CPU claims to not support PAT". "cleared" here does not 
> signify that we ourselves cleared anything, just that flag IS clear 
> (unset). Yes, maybe the wording could be better but it's not wrong.

Well, wording might not be best. But I don't care anymore.
(Just wondering which CPUs are out there that support PAT but don't
advertise it with any feature flag.)

>>   x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>>     (=> which is wrong as PAT shouldn't be enabled on such CPUs)
>
> Again not wrong, or at least by design. Thomas Gleixner did it this way and 
> with that "paranoia check" explicitly bombing out only for SMP this 
> wouldn't have been by accident. He no doubt knows why he did so (and he's 
> in CC so if we're real lucky we might also now...)

I guess at the time Thomas' patch was commited this was just fine.

But with the recent Transmeta/Centaur patch, validate_pat_support()
returns w/o disabling PAT even for such vendor's CPUs that don't
support PAT,

To prevent this, validate_pat_support() should check for cpu_has_pat
in addition to any other white-black-or-whatsoever-listing.


Regards,

Andreas


