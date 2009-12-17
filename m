Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZLQFn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZLQFn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZLQFnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:43:25 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58470
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZLQFnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:43:24 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Date: Wed, 16 Dec 2009 23:43:15 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: Roland Dreier <rdreier@cisco.com>, Michal Marek <mmarek@suse.cz>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <20091216235617.GA12267@hexapodia.org> <aday6l25gnm.fsf@roland-alpha.cisco.com> <4B29BFE8.1000502@zytor.com>
In-Reply-To: <4B29BFE8.1000502@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912162343.16541.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009 23:21:44 H. Peter Anvin wrote:
> On 12/16/2009 09:11 PM, Roland Dreier wrote:
> >  > As Al Viro said, if we run awk with LC_ALL=C, then the characters will
> >  > be sorted as ASCII. So, your patch is OK if you can add LC_ALL=C just
> >  > before $(AWK). (I'm not so sure whether Makefile can accept it...)
>
> I would strongly prefer the following solution as it solves this entire
> class of problems globally, although I'd really want Michal's ACK for it:
>
> diff --git a/Makefile b/Makefile
> index 33d4732..7fefc13 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -302,6 +302,10 @@ MAKEFLAGS += --include-dir=$(srctree)
>  $(srctree)/scripts/Kbuild.include: ;
>  include $(srctree)/scripts/Kbuild.include
>
> +# Avoid funny character set dependencies
> +LC_ALL=C
> +export LC_ALL
> +
>  # Make variables (CC, etc...)
>
>  AS		= $(CROSS_COMPILE)as

Agreed.  Otherwise we can get strange new breakabe in future just because 
somebody builds in a _locale_ we've never heard of.  We must specify this to 
get consistent behavior.

And keep in mind, specifying this _is_ part of POSIX 2008.  The standard is 
online, even:

  http://www.opengroup.org/onlinepubs/9699919799/utilities/awk.html#tag_20_06_08
  http://www.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap07.html#tag_07_02

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
