Return-Path: <linux-kernel-owner+w=401wt.eu-S1161098AbXDEDVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161098AbXDEDVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161108AbXDEDVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:21:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15692 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161098AbXDEDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:21:41 -0400
X-IronPort-AV: i="4.14,373,1170651600"; 
   d="scan'208"; a="33796687:sNHT25921161"
Subject: Re: [PATCH] blackfin arch: use boot_command_line instead of
	save_command_line in setup c file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070404080752.4c2375b2.randy.dunlap@oracle.com>
References: <1175668103.10608.39.camel@roc-desktop>
	 <20070404080752.4c2375b2.randy.dunlap@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 05 Apr 2007 11:21:11 +0800
Message-Id: <1175743271.17315.10.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 08:07 -0700, Randy Dunlap wrote:
> On Wed, 04 Apr 2007 14:28:23 +0800 Wu, Bryan wrote:
> 
> > 
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > ---
> >  arch/blackfin/kernel/setup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
> > index ce51882..9870c60 100644
> > --- a/arch/blackfin/kernel/setup.c
> > +++ b/arch/blackfin/kernel/setup.c
> > @@ -221,7 +221,7 @@ void __init setup_arch(char **cmdline_p)
> >  
> >  	/* Keep a copy of command line */
> >  	*cmdline_p = &command_line[0];
> > -	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
> > +	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
> >  	saved_command_line[COMMAND_LINE_SIZE - 1] = 0;
> >  
> >  	/* setup memory defaults from the user config */
> > -- 
> 
> Hi Bryan,
> 
> Patch descriptions should include _why_ a change is being made,
> not just what the change is.
> 

Thanks Randy. I am just confused by the following comments in -mm tree
init/main.c:
---
/* Untouched command line saved by arch-specific code. */
char __initdata boot_command_line[COMMAND_LINE_SIZE];
/* Untouched saved command line (eg. for /proc) */
char *saved_command_line;
---

And you know, in the 2.6.20.x stable kernel init/main.c:
---
/* Untouched command line (eg. for /proc) saved by arch-specific code. */
char saved_command_line[COMMAND_LINE_SIZE];
---

So the patch is to move saved_command_line to boot_command_line in
blackfin arch code. I will resend a new patch about this, because I
forgot to change :-<
---
-	saved_command_line[COMMAND_LINE_SIZE - 1] = 0;
+	boot_command_line[COMMAND_LINE_SIZE - 1] = 0;
---

Did I misunderstand about this? So some other arch (ARM/AVR32 ...)
should be updated, too. 

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Thanks again Randy.
I will follow the rule.

-Bryan
