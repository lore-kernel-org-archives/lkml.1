Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbXHTV2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbXHTV2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXHTV2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:28:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:41770 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXHTV2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:28:42 -0400
In-Reply-To: <20070820201818.A68C54D05F2@magilla.localdomain>
References: <20070820201818.A68C54D05F2@magilla.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7666a3cee89296540b8ade4bedc1e52e@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Paul Mackerras <paulus@samba.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [POWERPC] Fix for assembler -g
Date: Mon, 20 Aug 2007 23:28:33 +0200
To: Roland McGrath <roland@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm.  Check the V=1 make output to see that the lparmap.c really got 
> the -g0.
> The log says it didn't.  Oops!  It looks like the patch that got 
> committed is
> the one that sets CFLAGS_lparmap.s, but really it needs to set
> CFLAGS_lparmap.o instead (go kbuild).  Did I post the wrong one?  
> (It's only
> one letter different.)  Sorry about that!

But there is no lparmap.o!  lparmap.s is the generated file.

Maybe the best fix is

	$(obj)/lparmap.s: CFLAGS += -g0

This whole, erm, "cleverness" will go away soon fwiw.


Segher

