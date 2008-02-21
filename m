Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbYBUQjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbYBUQjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbYBUQi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:38:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:50523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYBUQiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:38:55 -0500
From: Andreas Schwab <schwab@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to do_div()
References: <20080221155402.4414.60360.stgit@warthog.procyon.org.uk>
X-Yow: Is this "BIKINI BEACH"?
Date: Thu, 21 Feb 2008 17:38:52 +0100
In-Reply-To: <20080221155402.4414.60360.stgit@warthog.procyon.org.uk> (David
	Howells's message of "Thu\, 21 Feb 2008 15\:54\:02 +0000")
Message-ID: <je4pc2s1r7.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

>  			if (time_offset < 0) {
> -			    temp64 = -temp64;
> -			    do_div(temp64, mtemp);
> +			    utemp64 = -temp64;
> +			    do_div(utemp64, mtemp);
>  			    freq_adj -= temp64;

do_div previously modified temp64 by side effect, now it no longer does
that.

>  			} else {
> -			    do_div(temp64, mtemp);
> +			    utemp64 = temp64;
> +			    do_div(utemp64, mtemp);
>  			    freq_adj += temp64;

Same.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
