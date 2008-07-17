Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbYGQTg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbYGQTg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYGQTf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:35:29 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:53019 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760714AbYGQTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:35:25 -0400
Date: Thu, 17 Jul 2008 14:35:16 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com
Subject: Re: [PATCH] elf loader support for auxvec base platform string
Message-ID: <20080717193516.GH9594@localdomain>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
 <1216166331-14810-2-git-send-email-ntl@pobox.com>
 <1216276539.7740.309.camel@pasglop>
 <alpine.LFD.1.10.0807170908060.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807170908060.2959@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 803257F4-5437-11DD-A7B3-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> 
> On Thu, 17 Jul 2008, Benjamin Herrenschmidt wrote:
> > 
> > Should I seek somebody's ack before merging a patch like the one below ?
> > 
> > I'm a bit reluctant to merge via the powerpc.git tree some changes to
> > generic files without at least an ack from somebody else :-)
> 
> Gaah. Generally we don't, but you're right to ask. The ELF loading keeps 
> on accumulating these things, and I'm not sure we have the right process 
> for things like this. They're all individually small and insignificant, 
> and they are all individually never going away and making the ELF loader 
> messier and messier.

FWIW, I was initially reluctant to do it this way, but the ELF aux
vector seems to be the only reasonable mechanism for getting this
information to all interested users.  And the only reason the patch
touches the generic code is because we have to copy a string to
userspace (just like AT_PLATFORM).  Otherwise it could be done in
powerpc's ARCH_DLINFO.
