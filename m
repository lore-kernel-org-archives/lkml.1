Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYKZNyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYKZNyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYKZNyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:54:12 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33847 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYKZNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:54:11 -0500
Date: Wed, 26 Nov 2008 14:54:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Detecting endianness in scripts/recordmcount.pl?
Message-ID: <20081126135441.GB28170@uranus.ravnborg.org>
References: <20081126083905.GA20472@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126083905.GA20472@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 05:39:05PM +0900, Paul Mundt wrote:
> Presently there doesn't seem to be any way to determine whether the
> target is big or little endian, and it is assumed that the compiler will
> do the right thing by default. Unfortunately this can not be assumed,
> and mismatches ensue, resulting in the linker bailing out.
> 
> The only obvious solution I saw was to pass in KBUILD_CFLAGS and ld_flags
> along with $(CC) and $(LD) to the script, and killing off the hardcoded
> flags. This at least gets things building, but that still leaves objcopy
> and objdump as the odd ones out. On the other hand, the format can be figured
> out by objdumping the object and reading in the file format line, but people
> obviously do not have consistent naming for these, and a double-pass would
> be needed -- once for establishing little or big, followed by figuring out
> which set of regexes to use.
> 
> The CONFIG_64BIT test could likewise be adopted for testing endianness, but
> not all architectures have config options for endian selections.
But we could add this - no?
Much better than executing objdump one thousand times.

	Sam
