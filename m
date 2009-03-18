Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZCRNoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZCRNoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZCRNn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:43:59 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55386 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZCRNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:43:59 -0400
Date: Wed, 18 Mar 2009 08:43:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Dan Smith <danms@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
Message-ID: <20090318134341.GB22636@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com> <1236095764-19325-3-git-send-email-danms@us.ibm.com> <1236097332.22399.8.camel@nimitz> <878wnmrtp9.fsf@caffeine.danplanet.com> <1236128437.22399.31.camel@nimitz> <20090304150519.GB10186@us.ibm.com> <49C0A80E.1040603@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C0A80E.1040603@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> >> On Tue, 2009-03-03 at 16:57 -0800, Dan Smith wrote:
> >>> DH> Did you convince Nathan that this ends up being a good idea?
> >>>
> >>> Technically he hasn't seen this version, but my hopes are not high
> >>> that he will change his mind.  If the feedback is that they're not
> >>> liked, I'll happily remove them.
> >> I just figure if Nathan feels that strongly that we'll encounter more
> >> people who feel even more so.  So, I was curious if he changed his mind
> >> somehow.
> > 
> > I maintain however that two strong advantages of moving the checkpoint
> > and restart of simple registers etc into a single function are:
> > 
> > 	1. we won't forget to add (or accidentally lose) one or the
> > 		other
> > 	2. any actual special handling at checkpoint or restart, like
> > 		the loading of access registers at restart on s390x,
> > 		stand out
> > 
> 
> I, too, think that this scheme is elegant, and at the same time I, too,
> think that it obfuscates the code. Since I only touch arch-dependent code
> only if I really really must, I don't have strong opinion about it ;)
> 
> However, a problem with this scheme is that checkpoint and restart
> are not fully symmetric -- on restart we must sanitize the input data
> before restoring the registers to that data. I'm not familiar with
> s390, but it is likely that by not doing so we create a security issue.
> 
> Oren.

But that's exactly why I think CR_COPY() helps - the sanitation is
explicit next to some boring CR_COPY()s.  It becomes clearer that
it is being done.

Anyway we've got plenty of other, bigger hurdles to clear, so while
I do have a strong opinion, I'm not planning on pushing hard either
way.

thanks,
-serge
