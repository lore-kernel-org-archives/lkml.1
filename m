Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXKLJny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXKLJny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 04:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbXKLJnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 04:43:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:36460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXKLJnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 04:43:45 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
Date: Mon, 12 Nov 2007 10:43:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
References: <10551261882075921134.slaby@pripojeni.net> <47362AF9.5080009@gmail.com> <20071112075452.GD9771@stusta.de>
In-Reply-To: <20071112075452.GD9771@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711121043.42745.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 12 November 2007 08:54:52, you (Adrian Bunk) wrote:
> On Sat, Nov 10, 2007 at 11:04:41PM +0100, Jiri Slaby wrote:
> > Why? Anyway I think this is the case. The body of the then branch is executed at
> > most once, while the else branch each time but last. If you write/read 1002
> > bytes, it means 250:1. ...and it's invoked from interrupt too...
> 
> AFAIK there is no well defined semantics whether likely/unlikely means 
> 10:1 or 10000:1 that is guaranteed to not change during the next
> 10 years.
> 
> Unless there's a measurable difference, it's best to write readable 
> C code and simply leave all optimizations to the compiler.

>From my (totally) beginners point of view i would have guessed a chance of
very well below one percent that this condition is true could be called
"unlikely",
but i have to admit this is most probably a much too naive way of thinking,
especially in regards of compiler optimizations.
And in this special case now there are already most calls (about 80 percent)
caught by the switch-case-shortcuts anyway.

So, i'll revert it.

Thanks a lot for your feedback,
Frank	
