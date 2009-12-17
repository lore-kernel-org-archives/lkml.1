Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbZLQNUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbZLQNUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZLQNUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:20:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZLQNUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:20:42 -0500
Message-ID: <4B2A3071.9000003@redhat.com>
Date: Thu, 17 Dec 2009 08:21:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com>
In-Reply-To: <adabphy750b.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Is there any reason not to apply the patch below, to allow more awk
> implementations to be used?  After all, it's not like we're going to put
> non-ASCII characters into the map file...
> 
> ===
> 
> x86: Don't use POSIX character classes in gen-insn-attr-x86.awk
> 
> Not all awk implementations (including the default awk in Ubuntu 9.10)
> support POSIX character classes.  Since x86-opcode-map.txt is plain
> ASCII, we can just use explicit ranges for lower case, alphabetic, and
> alphanumeric characters instead.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

As far as Peter's LC_* patch is accepted:), this looks good to me.
Thank you for fixing and discussing that!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  arch/x86/tools/gen-insn-attr-x86.awk |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
> index 7a68506..eaf11f5 100644
> --- a/arch/x86/tools/gen-insn-attr-x86.awk
> +++ b/arch/x86/tools/gen-insn-attr-x86.awk
> @@ -6,8 +6,6 @@
>  
>  # Awk implementation sanity check
>  function check_awk_implement() {
> -	if (!match("abc", "[[:lower:]]+"))
> -		return "Your awk doesn't support charactor-class."
>  	if (sprintf("%x", 0) != "0")
>  		return "Your awk has a printf-format problem."
>  	return ""
> @@ -44,12 +42,12 @@ BEGIN {
>  	delete gtable
>  	delete atable
>  
> -	opnd_expr = "^[[:alpha:]/]"
> +	opnd_expr = "^[A-Za-z/]"
>  	ext_expr = "^\\("
>  	sep_expr = "^\\|$"
> -	group_expr = "^Grp[[:alnum:]]+"
> +	group_expr = "^Grp[0-9A-Za-z]+"
>  
> -	imm_expr = "^[IJAO][[:lower:]]"
> +	imm_expr = "^[IJAO][a-z]"
>  	imm_flag["Ib"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
>  	imm_flag["Jb"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
>  	imm_flag["Iw"] = "INAT_MAKE_IMM(INAT_IMM_WORD)"
> @@ -62,7 +60,7 @@ BEGIN {
>  	imm_flag["Ob"] = "INAT_MOFFSET"
>  	imm_flag["Ov"] = "INAT_MOFFSET"
>  
> -	modrm_expr = "^([CDEGMNPQRSUVW/][[:lower:]]+|NTA|T[012])"
> +	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
>  	force64_expr = "\\([df]64\\)"
>  	rex_expr = "^REX(\\.[XRWB]+)*"
>  	fpu_expr = "^ESC" # TODO
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

