Return-Path: <linux-kernel-owner+w=401wt.eu-S1764065AbZLQIJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764065AbZLQIJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbZLQIJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:09:48 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:50437 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZLQIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:09:46 -0500
Date: Thu, 17 Dec 2009 09:09:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, Roland Dreier <rdreier@cisco.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Message-ID: <20091217080900.GA4010@merkur.ravnborg.org>
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com> <ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <20091217054524.GA3931@merkur.ravnborg.org> <4B29C81E.2000704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B29C81E.2000704@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:56:46PM -0800, H. Peter Anvin wrote:
> On 12/16/2009 09:45 PM, Sam Ravnborg wrote:
> >>
> >> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> >> index 45b20e4..0c46d60 100644
> >> --- a/arch/x86/lib/Makefile
> >> +++ b/arch/x86/lib/Makefile
> >> @@ -5,7 +5,7 @@
> >>  inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
> >>  inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
> >>  quiet_cmd_inat_tables = GEN     $@
> >> -      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
> >> +      cmd_inat_tables = LC_ALL=C $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
> > 
> > This will result in error messages in english always from awk - no?
> > Some people will care.
> > 
> 
> True, we probably don't want to set LC_MESSAGES.  Which means:
> 
> diff --git a/Makefile b/Makefile
> index 33d4732..357e83b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -302,6 +302,13 @@ MAKEFLAGS += --include-dir=$(srctree)
>  $(srctree)/scripts/Kbuild.include: ;
>  include $(srctree)/scripts/Kbuild.include
> 
> +# Avoid funny character set dependencies
> +LC_ALL=
> +LC_CTYPE=C
> +LC_COLLATE=C
> +LC_NUMERIC=C
> +export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
> +
>  # Make variables (CC, etc...)
> 
>  AS		= $(CROSS_COMPILE)as

Took a closer look at the patch.
I think we should move this upwards in the Makefile so it take effect as soon as possible.
Around the line where we do:

MAKEFLAGS += -rR --no-print-directory

	Sam
