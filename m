Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbZEVWS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbZEVWS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZEVWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:18:21 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:48141 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbZEVWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:18:21 -0400
Date: Fri, 22 May 2009 23:18:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
 and on.
In-Reply-To: <4A170713.402@zytor.com>
Message-ID: <alpine.LFD.1.10.0905222309180.19449@ftp.linux-mips.org>
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com> <20090522200239.GD5354@lenovo> <4A170713.402@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, H. Peter Anvin wrote:

> > actually this change could be dangerous. I don't
> > remember if I saw mixed configuration at all but
> > I would not be that sure that we will never met it.

 It is a matter of question whether this change gives any performance 
benefit, but certainly it is not dangerous.  What's the difference in code 
generated?

 Also APIC accesses cannot be cached, so access to the variable if hot in 
the cache should be faster, but OTOH if cold, then main RAM access may 
actually be slower as the APIC is quite closely coupled to the CPU.  Have 
any figures indicating performance change been obtained?

> That seems unlikely in the extreme.  To the best of my knowledge, only
> 486s ever used the external APICs.

 Several Pentium-based systems used external APICs (both ones built around 
original P5 and ones using P54C chips), but mixed configurations were not 
possible because of ICC bus/protocol incompatibility.  First of all the 
number of lines was different (5 vs 3)...

  Maciej
