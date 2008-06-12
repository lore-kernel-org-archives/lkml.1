Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYFLOmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYFLOmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYFLOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:42:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34660 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYFLOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:42:34 -0400
Date: Thu, 12 Jun 2008 16:43:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: Re: [GIT PULL] one kbuild fix for powerpc
Message-ID: <20080612144317.GA14397@uranus.ravnborg.org>
References: <20080612131650.GA13702@uranus.ravnborg.org> <25e057c00806120703g27566bd7ie522a7d5d4664d92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25e057c00806120703g27566bd7ie522a7d5d4664d92@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 04:03:54PM +0200, roel kluin wrote:
> 2008/6/12 Sam Ravnborg <sam@ravnborg.org>:
> 
> > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > index 508c589..b763aba 100644
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -467,6 +467,26 @@ static void parse_elf_finish(struct elf_info *info)
> >        release_file(info->hdr, info->size);
> >  }
> >
> > +static int ignore_undef_symbol(struct elf_info *info, const char *symname)
> > +{
> > +       /* ignore __this_module, it will be resolved shortly */
> > +       if (strcmp(symname, MODULE_SYMBOL_PREFIX "__this_module") == 0)
> > +               return 1;
> > +       /* ignore global offset table */
> > +       if (strcmp(symname, "_GLOBAL_OFFSET_TABLE_") == 0)
> > +               return 1;
> > +       if (info->hdr->e_machine == EM_PPC)
> > +               /* Special register function linked on all modules during final link of .ko */
> > +               if (strncmp(symname, "_restgpr_", sizeof("_restgpr_") - 1) == 0 ||
> > +                   strncmp(symname, "_savegpr_", sizeof("_savegpr_") - 1) == 0 ||
> > +                   strncmp(symname, "_rest32gpr_", sizeof("_rest32gpr_") - 1) == 0 ||
> > +                   strncmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0) {
> > +                       return 1;
> > +       }
> 
> Either the indentation is wrong, or you want to move the opening curly
> bracket upwards.

Deleted brackets - they are not needed.
And updated kbuild-fixes.git

	Sam
