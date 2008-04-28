Return-Path: <linux-kernel-owner+w=401wt.eu-S967089AbYD1XMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967089AbYD1XMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967312AbYD1XC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:02:26 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1312 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968010AbYD1XCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:02:24 -0400
Date: Tue, 29 Apr 2008 00:02:48 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why these dot chars in scripts/checkpatch.pl?
Message-ID: <20080428230248.GW5401@shadowen.org>
References: <20080428153122.a94d21ba.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428153122.a94d21ba.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 03:31:22PM -0500, Paul Jackson wrote:
> Andy,
> 
> Perhaps I'm loosing my magic regex pixie dust, but the dot '.' char
> in the pattern "/^.#" in the following lines looks wrong to me, as if
> one were trying to match pre-processor directives that were set in by
> one character:

This is because we always are dealing with diff lines, not real lines.
So there is always a ' ', '+', or '-' in character 0 of the line (within
a diff hunk).  In some tests we may be looking at either context ' '
or new lines '+' and so its handy to use '.' over '[ \+]', and I have
maintained that model throughout the other tests.

> The command:
> 
> 	grep '^[^#].*\/\^\.#' scripts/checkpatch.pl
> 
> displays:
> 
>         if ($res =~ /^.#\s*include\s+\<(.*)\>/) {
>         } elsif ($res =~ /^.#\s*(?:error|warning)\s+(.*)\b/) {
>                 if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
>                 if ($line =~ /^.#\s*if\s+0\b/) {
>                 if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
>                     $line !~ /^.#\s*if\b.*\bNR_CPUS\b/ &&
>                     $line !~ /^.#\s*define\b.*\bNR_CPUS\b/ &&
> 

-apw
