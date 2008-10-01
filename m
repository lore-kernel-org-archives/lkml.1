Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbYJAT4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbYJAT4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYJAT4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:56:42 -0400
Received: from gw.goop.org ([64.81.55.164]:40036 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbYJAT4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:56:41 -0400
Message-ID: <48E3D5F2.4090708@goop.org>
Date: Wed, 01 Oct 2008 12:56:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: akataria@vmware.com, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors and Linux.
References: <1222881242.9381.17.camel@alok-dev1> <48E3BBC1.2050607@goop.org> <48E3BC47.60900@zytor.com> <48E3BD83.2090801@goop.org> <48E3BE65.2050909@zytor.com> <48E3C32B.3090701@goop.org> <48E3C4C3.1050903@zytor.com>
In-Reply-To: <48E3C4C3.1050903@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> What you'd want, at least, is a standard CPUID identification and 
> range leaf at the top.  256 leaves is a *lot*, though; I'm not saying 
> one couldn't run out, but it'd be hard.  Keep in mind that for large 
> objects there are "counting" CPUID levels, as much as I personally 
> dislike them, and one could easily argue that if you're doing 
> something that would require anywhere near 256 leaves you probably are 
> storing bulk data that belongs elsewhere.

I agree, but it just makes the proposal a bit more brittle.

> Of course, if we had some kind of central authority assigning 8-bit 
> IDs that would be even better, especially since there are tools in the 
> field which already scan on 64K boundaries.  I don't know, though, how 
> likely it is that we'll have to deal with 256 hypervisors.

I'm assuming that the likelihood of getting all possible vendors - 
current and future - to agree to a scheme like this is pretty small.  We 
need to come up with something that will work well when there are 
non-cooperative parties to deal with.

> I agree completely, of course (except that "what hypervisor is this" 
> still has limited usage, especially when it comes to dealing with bug 
> workarounds.  Similar to the way we use CPU vendor IDs and stepping 
> numbers for physical CPUs.)

I guess.  Its certainly useful to be able to identify the hypervisor for 
bug reporting and just general status information.  But making 
functional changes on that basis should be a last resort.

    J
