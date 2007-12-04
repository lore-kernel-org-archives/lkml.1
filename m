Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbXLDTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbXLDTL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXLDTLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:11:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbXLDTLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:11:17 -0500
Date: Tue, 4 Dec 2007 11:10:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, roland@redhat.com,
       mathieu.desnoyers@polymtl.ca, dsmith@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] Linux Kernel Markers - Create modpost file
Message-Id: <20071204111026.9f7d8ed5.akpm@linux-foundation.org>
In-Reply-To: <20071204182403.319351701@polymtl.ca>
References: <20071204181845.895090222@polymtl.ca>
	<20071204182403.319351701@polymtl.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 13:18:47 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> This adds some new magic in the MODPOST phase for CONFIG_MARKERS.
> Analogous to the Module.symvers file, the build will now write a
> Module.markers file when CONFIG_MARKERS=y is set.  This file lists
> the name, defining module, and format string of each marker,
> separated by \t characters.  This simple text file can be used by
> offline build procedures for instrumentation code, analogous to
> how System.map and Module.symvers can be useful to have for
> kernels other than the one you are running right now.
> 
> The strings are made easy to extract by having the __trace_mark macro
> define the name and format together in a single array called __mstrtab_*
> in the __markers_strings section.  This is straightforward and reliable
> as long as the marker structs are always defined by this macro.  It is
> an unreasonable amount of hairy work to extract the string pointers from
> the __markers section structs, which entails handling a relocation type
> for every machine under the sun.
> 
> Mathieu :
> - Ran through checkpatch.pl
> 
> ...
>
> --- linux-2.6-lttng.orig/scripts/mod/modpost.c	2007-11-21 20:54:17.000000000 -0500
> +++ linux-2.6-lttng/scripts/mod/modpost.c	2007-11-21 21:19:19.000000000 -0500
> @@ -11,6 +11,8 @@
>   * Usage: modpost vmlinux module1.o module2.o ...
>   */
>  
> +#define _GNU_SOURCE

Why was the mystery addition of _GNU_SOURCE made?

> +#include <stdio.h>
>  #include <ctype.h>
>  #include "modpost.h"
>  #include "../../include/linux/license.h"
> @@ -424,6 +426,8 @@ static int parse_elf(struct elf_info *in

These two patches are unfortunately large, intrusive and tricky to be
turning up in -rc4.

