Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbXIPS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbXIPS16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXIPS1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:27:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58067 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbXIPS1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:27:50 -0400
Date: Sun, 16 Sep 2007 20:29:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [patch 01/03] kbuild, asm-values: infrastructure
Message-ID: <20070916182912.GA9630@uranus.ravnborg.org>
References: <20070612233650.486224000@flower.upol.cz> <20070612234558.648949000@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612234558.648949000@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg.

On Wed, Jun 13, 2007 at 01:36:51AM +0200, Oleg Verych wrote:
> 	* header with widely used value definitions
> 	* handle all asm-related things in one file (Makefile.asm)
> 	* move some asm bits from Makefile.build there
> 	  (rule %.s:%.c)
> 	* add script to generate headers from assembles output
> 	  (hopefully better output, MIPS testing/joining to all arch
> 	   probably needed)
> 

Took a look at this patch at last.
Your patch moves everything to Makefile.asm and uses a script
to generate the offset file.

Now where we go the step to use a script to generate the offset file
a much simpler approach would be to move both steps to the shell script.
So the script are called with the input file as one of the
arguments and it spits out the resulting file to stdout.

Doing it this way would allow the caller to have full control
on the filenames and the current call-site in top-level Kbuild
would still be much simpler than today.

Moving the bits from Makefile.build that is only used for asm-offset is
a nice cleanup and this should the script version support too.

I see no value in renaming from asm_offset to asm_value - please drop it.
Introducing the generic asm-values.h should wait and when you do
you should be preapred to update all architectures (ecasue otherwise it
will not happen).

Sorry for the late feedback.

	Sam
