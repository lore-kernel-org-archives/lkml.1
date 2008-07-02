Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYGBOgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYGBOgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYGBOgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:36:13 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:65516 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYGBOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:36:12 -0400
Date: Wed, 2 Jul 2008 09:35:54 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
Message-ID: <20080702143554.GY9594@localdomain>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
 <20080702003755.4daff613.akpm@linux-foundation.org>
 <87r6acsfo1.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6acsfo1.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 36787638-4844-11DD-9EF7-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > sysfs is part of the kernel ABI.  We should design our interfaces there
> > as carefully as we design any others.
> 
> The basic problem is that sysfs exports an internal kernel object model
> and these tend to change. To really make it stable would require 
> splitting it into internal and presented interface.

True, but... /sys/devices/system/cpu has been there since around 2.6.5
iirc.  A google code search for that path shows plenty of programs
(including hal) that hard-code it.  Exposed object model or not,
changing that path would break lots of software.


> I would be all
> for it, but it doesn't seem realistic to me currently. If we cannot
> even get basic interfaces like the syscall capability stable how would
> you expect to stabilize the complete kobjects? 
> 
> And the specific problem with the x86 cache sysfs interface is that it's so
> complicated that no human can really read it directly. This means to
> actually use it you need some kind of frontend (i have a cheesy
> lscache script for this).

Human readability is nice, but a more important issue IMO is whether
the cache interface can be considered stable enough for programs to
rely on it.  I notice there's no entry for it in Documentation/ABI.

