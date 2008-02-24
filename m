Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYBXHek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYBXHek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBXHeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:34:31 -0500
Received: from mail08a.verio.de ([213.198.55.73]:17993 "HELO mail08a.verio.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751254AbYBXHe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:34:29 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 02:34:29 EST
Message-Id: <6.1.1.1.2.20080224082113.01e51e50@192.168.6.12>
X-Mailer: QUALCOMM Windows Eudora Version 6.1.1.1
Date: Sun, 24 Feb 2008 08:27:30 +0100
To: linux-kernel@vger.kernel.org
From: Roger While <simrw@sim-basis.de>
Subject: Re: [patch 1/2] x86,fpu: split FPU state from task struct
Cc: suresh.b.siddha@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-SIMBasis-MailScanner-Information: Please contact the ISP for more information
X-SIMBasis-MailScanner: Found to be clean
X-SIMBasis-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (score=-5.899, required 5, autolearn=not spam,
	ALL_TRUSTED -3.30, BAYES_00 -2.60)
X-SIMBasis-MailScanner-From: simrw@sim-basis.de
X-Spam: [F=0.3029429977; heur=0.500(-6600); stat=0.302; spamtraq-heur=0.500(2007101727)]
X-MAIL-FROM: <simrw@sim-basis.de>
X-SOURCE-IP: [213.198.55.139]
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, Feb 23, 2008 at 06:34:38PM -0800, Suresh Siddha wrote:
 > Split the FPU save area from the task struct. This allows easy migration
 > of FPU context, and it's generally cleaner. It also allows the following
 > two optimizations:
 >
 > 1) only allocate when the application actually uses FPU, so in the first
 > lazy FPU trap. This could save memory for non-fpu using apps. Next patch
 > does this lazy allocation.
 >
 > 2) allocate the right size for the actual cpu rather than 512 bytes always.
 > Patches enabling xsave/xrstor support (coming shortly) will take advantage
 > of this.

 >  	if (next_p->fpu_counter>5)
 > -		prefetch(&next->i387.fxsave);
 > +		prefetch(FXSAVE(next_p));

Shouldn't that be  prefetch(FXSAVE(next));  ?

Roger


