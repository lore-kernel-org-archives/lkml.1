Return-Path: <linux-kernel-owner+w=401wt.eu-S1030313AbXCMORy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030313AbXCMORy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030365AbXCMORy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:17:54 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:49913 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030313AbXCMORx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:17:53 -0400
From: Arnaud Giersch <arnaud.giersch@free.fr>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanfile: a script to clean up stealth whitespace
References: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org>
Date: Tue, 13 Mar 2007 15:16:48 +0100
In-Reply-To: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org> (H. Peter
	Anvin's message of "Mon, 12 Mar 2007 12:16:30 -0700")
Message-ID: <87abyh1b5b.fsf@groumpf.homeip.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lundi 12 mars 2007, vers 20:16:30 (+0100), H. Peter Anvin a écrit:

> This script cleans up various classes of stealth whitespace.  In
> particular, it cleans up:
>
> - Whitespace (spaces or tabs)before newline;
> - DOS line endings (CR before LF);
> - Space before tab (spaces are deleted or converted to tabs);
> - Empty lines at end of file.

What about checking for a newline at end of file?  Something like:

[...]

> +    if ($is_binary) {
> +	print STDERR "$name: $f: binary file\n";
> +	next;
> +    }

    # Add a newline at end of file, if needed.
    seek(FILE, -1, 2);
    if (read(FILE, $last_char, 1) == 1 && $last_char ne "\n") {
	seek(FILE, 0, 2);
	print FILE "\n";
    }

> +    seek(FILE, 0, 0);
> +
> +    $in_bytes = 0;
> +    $out_bytes = 0;
> +    $blank_bytes = 0;

[...]

Regards,
        Arnaud Giersch
