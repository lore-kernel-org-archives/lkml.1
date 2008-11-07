Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKGNRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKGNRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYKGNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:17:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYKGNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:17:41 -0500
Subject: Re: [PATCH] ftrace: Allow section alignment
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <mjf@gentoo.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>
References: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Nov 2008 14:18:16 +0100
Message-Id: <1226063896.2697.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 13:12 +0000, Matt Fleming wrote:
> Provide a means of aligning the __mcount_loc section.

Not that I object to the patch, but this changelog needs work.

Its wrong, it doesn't provide means, it plain does.
It doesn't tell us why.

> Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
> ---
>  scripts/recordmcount.pl |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 6b9fe3e..2d0bfa1 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -134,6 +134,7 @@ my $section_regex;  # Find the start of a section
>  my $function_regex;    # Find the name of a function
>                         #    (return offset and func name)
>  my $mcount_regex;      # Find the call site to mcount (return offset)
> +my $alignment;         # The .align value to use for $mcount_section
> 
>  if ($arch eq "x86") {
>      if ($bits == 64) {
> @@ -148,6 +149,7 @@ if ($arch eq "x86_64") {
>      $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
>      $type = ".quad";
> +    $alignment = 8;
> 
>      # force flags for this arch
>      $ld .= " -m elf_x86_64";
> @@ -160,6 +162,7 @@ if ($arch eq "x86_64") {
>      $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
>      $type = ".long";
> +    $alignment = 4;
> 
>      # force flags for this arch
>      $ld .= " -m elf_i386";
> @@ -288,6 +291,7 @@ sub update_funcs
>             open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
>             $opened = 1;
>             print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
> +           print FILE "\t.align $alignment\n";
>         }
>         printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
>      }
> --
> 1.5.6.4
