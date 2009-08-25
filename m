Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZHYTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZHYTkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZHYTkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:40:18 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61416 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZHYTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LiQP/wBS7kd5iMN5/STxNqGwWsdNvsW1dxh+6IKSLXlSt3D7X5HrtvuYw75hQt+oBf
         9QVM8ZRPpzDPx5D9EQGP8oe/cdtgrql2ej8DHwbNWqQJNfFbM1WQsE85hWlMdnhrm4y5
         rRtHzCuKEpSdqSuq5K0zX1d3Yv4ngSbZVWcQc=
Date: Tue, 25 Aug 2009 23:40:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825194011.GD5806@lenovo>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <20090825192055.GD6456@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825192055.GD6456@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ravikiran G Thirumalai - Tue, Aug 25, 2009 at 12:20:55PM -0700]
| On Tue, Aug 25, 2009 at 10:31:30PM +0400, Cyrill Gorcunov wrote:
| >[Ingo Molnar - Tue, Aug 25, 2009 at 08:15:00PM +0200]
| >| 
| >
| >I'm definitely not APIC expert but since I was partially involved
| >letme turn in.
| >
| >Original commit which causes problem for vSMP seems to be due
| >to cpu_has_apic bit turned off (ie due to being manually disabled
| >or acpi table broken) so further read apic id will return plain
| >zero (we're talking about 64 bits now). So frnakly I don't understand
| >what is wrong with Ravikiran's patch. In case of apic disabled
| >initial apic value will be used anyway (which is latched but
| >actually may be changed, but it's not our case).
| >
| 
| Exactly my thinking.  I hoped the patch I posted solves both cases --
| does not depend on local apic id for the "fix crash on certain UP configs"
| case in the commit here:
| 
| http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2759c3287de27266e06f1f4e82cbd2d65f6a044c
| 
| And fixes vsmp too.
| 
| >Or perhaps there is an issue in srat numa nodes numbering?
| >
| 
| Don't think so, local apic id has been used for for 'flat' and 'cluster'
| apic (which was used prior to 'flat') for atleast 15 major releases.
| 
| Cyrill/Yinghai, can you test and confirm if the patch attached does not
| regress the 'UP crash case' mentioned in
| commit 2759c3287de27266e06f1f4e82cbd2d65f6a044c please?
| 
| ---
| 

I would like to but I can;t. I don;t even know where were we hanging
at this crash case. I was only reading commit changelog and since
it was said about "not apic bit set" I thought about disabled apic case.

Personally I like much more quirk Yinghai posted which leaves phys id function
_bared_ and simple as it should be :)

And since it's too late before kernel release -- introducing read apic back
seems to be dangerous I suppose: there are a number of configs which could
be having side effect. At moment they are tested _with_ Yinghai patch and
only vSMP is issued. Though the problem need to be investigated more
closely. But I'm not knowing that much in this area.

	-- Cyrill
