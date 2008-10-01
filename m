Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYJAWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYJAWvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYJAWvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:51:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYJAWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:51:00 -0400
Message-ID: <48E3FDD5.7040106@zytor.com>
Date: Wed, 01 Oct 2008 15:46:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Daniel Hecht <dhecht@vmware.com>, Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1>
In-Reply-To: <1222895153.9381.69.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
>> No, that's always a terrible idea.  Sure, its necessary to deal with
>> some backward-compatibility issues, but we should even consider a new
>> interface which assumes this kind of thing.  We want properly enumerable
>> interfaces.
> 
> The reason we still have to do this is because, Microsoft has already
> defined a CPUID format which is way different than what you or I are
> proposing ( with the current case of 256 leafs being available). And I
> doubt they would change the way they deal with it on their OS. 
> Any proposal that we go with, we will have to export different CPUID
> interface from the hypervisor for the 2 OS in question. 
> 
> So i think this is something that we anyways will have to do and not
> worth binging about in the discussion.

No, that's a good hint that what "you and I" are proposing is utterly 
broken and exactly underscores what I have been stressing about 
noncompliant hypervisors.

All I have seen out of Microsoft only covers CPUID levels 0x40000000 as 
an vendor identification leaf and 0x40000001 as a "hypervisor 
identification leaf", but you might have access to other information.

This further underscores my belief that using 0x400000xx for anything 
"standards-based" at all is utterly futile, and that this space should 
be treated as vendor identification and the rest as vendor-specific. 
Any hope of creating a standard that's actually usable needs to be 
outside this space, e.g. in the 0x40SSSSxx space I proposed earlier.

	-hpa
