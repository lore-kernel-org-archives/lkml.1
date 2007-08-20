Return-Path: <linux-kernel-owner+w=401wt.eu-S1764327AbXHTU2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764327AbXHTU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXHTUYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:24:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762874AbXHTUX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:23:59 -0400
Date: Mon, 20 Aug 2007 16:23:56 -0400
From: Dave Jones <davej@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [POWERPC] Fix for assembler -g
Message-ID: <20070820202356.GA31712@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Roland McGrath <roland@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>
References: <20070820200856.GA4194@redhat.com> <20070820201818.A68C54D05F2@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820201818.A68C54D05F2@magilla.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 01:18:18PM -0700, Roland McGrath wrote:
 > > I'm still seeing failures with this.
 > > http://koji.fedoraproject.org/koji/getfile?taskID=110854&name=build.log
 > > shows..
 > > 
 > > lparmap.c: Assembler messages:
 > > lparmap.c:84: Error: file number 1 already allocated
 > > make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
 > > 
 > > Anything I can provide to help diagnose this?
 > 
 > Hmm.  Check the V=1 make output to see that the lparmap.c really got the -g0.
 > The log says it didn't.  Oops!  It looks like the patch that got committed is
 > the one that sets CFLAGS_lparmap.s, but really it needs to set
 > CFLAGS_lparmap.o instead (go kbuild).  Did I post the wrong one?  (It's only
 > one letter different.)  Sorry about that!  (I committed the right one to
 > Fedora, which you'd think would help Dave, but no.)
 
Ahh, my eyes missed that the one upstream was subtley different, so I
dropped the one you committed to Fedora without trying it.
In a way though, good thing, or mainline would have continued to be
broken :)

	Dave

-- 
http://www.codemonkey.org.uk
