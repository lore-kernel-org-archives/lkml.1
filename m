Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZJNHoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZJNHoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbZJNHoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:44:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbZJNHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:44:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jeUHQjw5hQyGvpd/K0U6pXuqrE0rxHE1Dy8vdEVONf8G3JHf0F9ZvWTPzGq47o3nX
	2dGLctGYmnVAptSmvo8Aw==
Date: Wed, 14 Oct 2009 00:42:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <20091014073306.GB22778@elte.hu>
Message-ID: <alpine.DEB.1.00.0910140037140.29264@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain>
 <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com> <20091014065941.GH784@elte.hu> <alpine.DEB.1.00.0910140014490.26562@chino.kir.corp.google.com> <20091014073306.GB22778@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Ingo Molnar wrote:

> > Regardless of future improvements, I think my two patches allow the 
> > kernel version to more accurately describe what is running.  That is 
> > predicated on my belief that "v2.6.32-rc4", though, should never 
> > describe _anything_ except the kernel.org v2.6.32-rc4 kernel.
> 
> I agree with all that - in fact i started this thread by stating that 
> view and suggesting the '+' extension to the short version name.
> 

Yeah, my patches build upon the base that you originally proposed.  I like 
the `+' suffix for configs with CONFIG_LOCALVERSION_AUTO that aren't 
vanilla kernels.

> But there's been packaging related objections from Frans and others, and 
> i suspect you'll need to answer/address those instead of further 
> detailing the virtues of proper version names (which i still 100% agree 
> with).
> 

We could easily go with my suggestion of allowing "make LOCALVERSION=" to 
override all additions to the kernel version when CONFIG_LOCALVERSION_AUTO 
is disabled.  For such configurations, kernels would be built with this 
variable to specify how it's different from the vanilla version and would 
suppress the `+'.

Frans and others, how does adding a unique string passed by the user for a 
more descriptive kernel version interact poorly with certain packaging 
requirements?
