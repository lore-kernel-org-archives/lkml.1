Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZDOVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZDOVTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZDOVTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:19:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36633 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZDOVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:19:32 -0400
Date: Wed, 15 Apr 2009 23:21:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: devzero@web.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: Should MODULE_DESCRIPTION be mandatory ?
Message-ID: <20090415212138.GB27597@uranus.ravnborg.org>
References: <671646821@web.de> <20090415194226.GB25783@uranus.ravnborg.org> <49E64E86.4080109@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49E64E86.4080109@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 02:15:50PM -0700, Randy Dunlap wrote:
> Sam Ravnborg wrote:
> > On Wed, Apr 15, 2009 at 01:11:46PM +0200, devzero@web.de wrote:
> >> Hi, 
> >>
> >> some time ago i spotted that around 20% of the Linux modules lacking a MODULE_DESCRIPTION field.  ( http://bugzilla.kernel.org/show_bug.cgi?id=10770 )
> >>
> >> I think it`s not a practicable approach to get this fixed by some single person digging trough all the modules. 
> >> If itŽs fixed for a kernel release, one year later there would be another bunch of new modules lacking the description field again.
> >>
> >> What about a build-time or run-time warning for missing MODULE_DESCRIPTION ? (as it exists for MODULE_LICENSE in modpost.c) 
> > 
> > 
> > You mean something like the following untested patch?
> > If it works what is the output for an allmodconfig build?
> > 
> > 	Sam
> > 
> > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > index 8cc7061..5317d6f 100644
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -1553,6 +1553,7 @@ static void read_symbols(char *modname)
> >  	const char *symname;
> >  	char *version;
> >  	char *license;
> > +	char *description;
> >  	struct module *mod;
> >  	struct elf_info info = { };
> >  	Elf_Sym *sym;
> > @@ -1584,6 +1585,11 @@ static void read_symbols(char *modname)
> >  		license = get_next_modinfo(info.modinfo, info.modinfo_len,
> >  					   "license", license);
> >  	}
> > +	description = get_modinfo(info.modinfo, info.modinfo_len, "description");
> > +	if (info.modinfo && !description && !is_vmlinux(modname))
> > +		warn("modpost: missing MODULE_DESCRIPTION() in %s\n"
> > +		     "see include/linux/module.h for "
> > +		     "more information\n", modname);
> >  
> >  	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
> >  		symname = info.strtab + sym->st_name;
> > --
> 
> on x86_64 allmodconfig (2.6.30-rc2), here are the "missing"s that are reported:
> 
> WARNING: modpost: missing MODULE_DESCRIPTION() in Documentation/filesystems/configfs/configfs_example_explicit.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in Documentation/filesystems/configfs/configfs_example_macros.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/ia32/ia32_aout.o
...
We need to bring that list down before we apply the patch.
Is it worth it?

	Sam
