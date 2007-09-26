Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbXIZPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbXIZPoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbXIZPoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:44:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33889 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbXIZPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:44:01 -0400
Date: Wed, 26 Sep 2007 11:43:21 -0400
Message-Id: <200709261543.l8QFhLC0028883@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops 
In-reply-to: Your message of "Wed, 26 Sep 2007 11:23:19 EDT."
             <2DDDD55D-4445-4565-9384-4E4BE7B41D7D@mac.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <2DDDD55D-4445-4565-9384-4E4BE7B41D7D@mac.com>, Kyle Moffett writes:
> On Sep 26, 2007, at 09:40:20, Erez Zadok wrote:
[...]
> > Recently we've done a full audit of the entire code, and added un/ 
> > likely where we felt that the chance of succeeding is 95% or better  
> > (e.g., error conditions that should rarely happen, and such).
> 
> Actually due to the performance penalty on some systems I think you  
> only want to use it if the chance of succeeding is 99% or better, as  
> the benefit if predicted is a cycle or two and the harm if  
> mispredicted can be more than 50 cycles, depending on the CPU.

*That's* the information I was looking for, Kyle: what's the estimated
probability I should be using as my guideline.  I used 95% (20/1 ratio), and
you're telling me I should use 99% (100/1 ratio).  The difference between
the number of cycles saved/added is very compelling.  Given that I certainly
agree with you that I'm using un/likely too much.  I'll re-evaluate and
update my patch series then.

Thanks,
Erez.
