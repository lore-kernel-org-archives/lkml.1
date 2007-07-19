Return-Path: <linux-kernel-owner+w=401wt.eu-S936400AbXGSBie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400AbXGSBie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934314AbXGSBiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:38:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934215AbXGSBiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:38:15 -0400
Date: Wed, 18 Jul 2007 18:37:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
In-Reply-To: <20070718235504.GA9601@havoc.gtf.org>
Message-ID: <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
References: <20070718235504.GA9601@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Jeff Garzik wrote:
> 
> Please pull from 'warnings' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings
> 
> to receive the following updates:

Quite frankly, I think a *lot* better fix for warnings would be to remove 
those damn broken "must_check" things on functions that don't at all need 
checking!

I'm pretty fed up with random "must_check" and "deprecated". They have 
never *ever* helped anybody, afaik. There are some very few functions that 
really do need to have their error returns checked (because not checking 
it is a security issue), but people seem to think "must_check" is a good 
approximation of "I think most of the time it makes sense to check".

So let's make a new rule:

  We absolutely NEVER add things like "must_check" unless not checking 
  causes a real and obvious SECURITY ISSUE.

  And we absolutely *never* add crap like "deprecated", where the only 
  point of the warning is to effectively hide *real* problems.

So realistically, the only thing that needs must_check is pretty much 
things like "get_user()" and quite frankly, I'm not sure even about that 
one.

Ok?

			Linus
