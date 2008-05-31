Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbYEaXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbYEaXLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYEaXLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:11:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:59378 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbYEaXLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pZFIqnsdRZpytKYZNOTFzbtT+B3/T5NfV+Jb+RbvzBFydNPAvHTPO5m19HrBw1C/67Kysn0NNpBr+OS2+F4/rmjfAhKSPamjOKkS9TijmleDG3ZigTuFVSUnSZqvTPl1MO3m+SdsvQ65FEu7XGjeSDNOMo+okIQOzNq/+9hJ1WY=
Message-ID: <19f34abd0805311611x29b6a4aas572ee180ef7eb2c7@mail.gmail.com>
Date: Sun, 1 Jun 2008 01:11:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ben Hutchings" <bhutchings@solarflare.com>
Subject: Re: [PATCH] cputopology: Add default CPU topology information [3rd try]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080531214429.GQ1743@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080531214429.GQ1743@solarflare.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 11:44 PM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> Define the macros topology_{physical_package,core}_id() and
> topology_{thread,core}_siblings() in <asm-generic/topology.h> if they are not
> already defined.
>
> Move inclusion of <asm-generic/topology.h> after definitions of these
> macros in <asm-powerpc/topology.h> and <asm-x86/topology.h>.

Hi again :)

As I said in my previous e-mail, having #includes in the middle of
headers is nasty. This kind of dependency is really subtle and makes
later modification much harder. (Actually, it hurts readability as
well.)

The standard way to do this seems to be:

asm/topology.h should define ARCH_HAS_* macros if it wishes to
override the defaults
linux/topology.h should #include asm/topology.h at the top of the file
linux/topology.h should define the generic functions/macros only if
the ARCH_HAS_* macros are undefined

Other files wishing to use these definitions should then include
linux/topology.h.

Or is that unfeasible in this case?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
