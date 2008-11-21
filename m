Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYKUHqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYKUHqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYKUHpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:45:53 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:10247 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbYKUHpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:45:53 -0500
Date: Fri, 21 Nov 2008 16:44:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Matt Fleming <mjf@gentoo.org>, Jim Radford <radford@galvanix.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] sh: dynamic ftrace support.
Message-ID: <20081121074428.GC28447@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
	Matt Fleming <mjf@gentoo.org>, Jim Radford <radford@galvanix.net>,
	Steven Rostedt <srostedt@redhat.com>
References: <20081120203415.251344054@goodmis.org> <20081120203551.633484431@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120203551.633484431@goodmis.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 03:34:16PM -0500, Steven Rostedt wrote:
> +} elsif ($arch eq "sh") {
> +    $section_regex = "Disassembly of section\\s+(\\S+):";
> +    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
> +    $type = ".long";
> +
> +    # force flags for this arch
> +    $ld .= " -m shlelf_linux";
> +    $objcopy .= " -O elf32-sh-linux";
> +    $cc .= " -m32";
> +

Note that if the $alignment changes are in this version, you will also
need to add an $alignment = 2; for sh. That was in Matt's original patch,
but I stripped the alignment line out in the commit given that it was not
yet present in the mainline version of the script.
