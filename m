Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZDOBqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZDOBqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbZDOBqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:46:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055AbZDOBqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:46:13 -0400
Message-ID: <49E53B31.6060704@redhat.com>
Date: Tue, 14 Apr 2009 21:41:05 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "xorg-devel@lists.x.org" <xorg-devel@lists.x.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "notting@redhat.com" <notting@redhat.com>,
       Fu Michael <michael_fu@linux.intel.com>
Subject: Re: [PATCH] drm: ignore LVDS on intel graphics systems that lie	about
 having it
References: <200904061011.26389.jarod@redhat.com> <20090406095216.4361d128@hobbes> <20090407005000.GA20908@zhen-devel.sh.intel.com>
In-Reply-To: <20090407005000.GA20908@zhen-devel.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2009 08:50 PM, Wang, Zhenyu Z wrote:
> On 2009.04.07 00:52:16 +0800, Jesse Barnes wrote:
>> On Mon, 6 Apr 2009 10:11:25 -0400
>> Jarod Wilson<jarod@redhat.com>  wrote:
>>
>>> There are a number of small form factor desktop systems with Intel
>>> mobile graphics chips that lie and say they have an LVDS. With kernel
>>> mode-setting, this becomes a problem, and makes native resolution
>>> boot go haywire -- for example, my Dell Studio Hybrid, hooked to a
>>> 1920x1080 display claims to have a 1024x768 LVDS, and the resulting
>>> graphical boot on the 1920x1080 display uses only the top left
>>> 1024x768, and auto-configured X will end up only 1024x768 as well.
>>> With this change, graphical boot and X both do 1920x1080 as expected.
>>>
>>> Note that we're simply embracing and extending the early bail-out code
>>> in place for the Mac Mini here. The xorg intel driver uses pci
>>> subsystem device and vendor id for matching, while we're using dmi
>>> lookups here. The MSI addition is courtesy of and tested by Bill
>>> Nottingham.
>>>
>>> One minor issue... Current Fedora rawhide, video playback using Xv
>>> makes X go off into the weeds with this patch added, but that's a bug
>>> elsewhere, still confident this patch DTRT.

As it turns out, this part is resolution-specific and kms-specific... 
When hooked up to a 1280x1024 monitor with or without kms enabled, no 
problems at all. When hooked to my HDTV, outputting at 1920x1080 with 
kms disabled, no problems. Only at 1920x1080 with kms enabled do things 
go sideways. Not sure exactly what the resolution tipping point is.


>> The 2D driver has a similar set of quirks, but since we started that
>> list we've found that the VBIOS should contain a pretty reliable table
>> indicating which outputs are available, including LVDS.  I think if we
>> can figure out how to parse it reliably (accounting for VBIOS
>> versioning and structure size changes) we shouldn't need this patch.
>> If we can't get that done in time for 2.6.30 though I'm all for
>> including this.
>>
>> Zhenyu and Michael does that sound doable?
>>
>
> yeah, that's what I tried to fix, instead of adding quirks in KMS,
> we try to find a way to detect LVDS config based on VBIOS table.
> But looks failed in first round as I haven't got full right info
> on VBIOS LVDS config. Old machines might not have correct VBIOS setting,
> and I'm not sure about those Intel Mac machines. So this one is fine to me too.

So is there still work being done to probe the VBIOS, or has that 
already proven to be fraught with peril? (In which case, what say we 
throw this in sooner than later?).

-- 
Jarod Wilson
jarod@redhat.com

