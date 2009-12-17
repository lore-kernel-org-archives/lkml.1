Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZLQFqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZLQFqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZLQFqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:46:47 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33694 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZLQFqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:46:47 -0500
Date: Thu, 17 Dec 2009 06:45:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Andrew Isaacson <adi@vmware.com>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Message-ID: <20091217054524.GA3931@merkur.ravnborg.org>
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com> <ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday6l25gnm.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:11:09PM -0800, Roland Dreier wrote:
> 
>  > As Al Viro said, if we run awk with LC_ALL=C, then the characters will be
>  > sorted as ASCII. So, your patch is OK if you can add LC_ALL=C just before
>  > $(AWK). (I'm not so sure whether Makefile can accept it...)
> 
> OK, updated patch:
> 
> ===
> 
> x86: Don't use POSIX character classes in gen-insn-attr-x86.awk
> 
> Not all awk implementations (including the default awk in Ubuntu 9.10)
> support POSIX character classes.  Since x86-opcode-map.txt is plain
> ASCII, we can just use explicit ranges for lower case, alphabetic, and
> alphanumeric characters instead.  We set LC_ALL=C when invoking awk so
> that ASCII ranges are never misinterpreted.
> 
> I verified that the Debian version of mawk, which doesn't have POSIX
> character set suport, generates the byte-for-byte the same inat-tables.c
> after this patch as gawk did on an unpatched kernel.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  arch/x86/lib/Makefile                |    2 +-
>  arch/x86/tools/gen-insn-attr-x86.awk |   10 ++++------
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index 45b20e4..0c46d60 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -5,7 +5,7 @@
>  inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
>  inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
>  quiet_cmd_inat_tables = GEN     $@
> -      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
> +      cmd_inat_tables = LC_ALL=C $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@

This will result in error messages in english always from awk - no?
Some people will care.

	Sam
