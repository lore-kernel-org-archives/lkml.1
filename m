Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXLEU6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXLEU6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXLEU6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:58:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58875 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbXLEU6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:58:15 -0500
Date: Wed, 5 Dec 2007 22:00:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071205210003.GA15366@uranus.ravnborg.org>
References: <20071204210433.4d7ee66c@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204210433.4d7ee66c@osprey.hogchain.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 09:04:33PM -0600, Jay Cliburn wrote:
> Sam,
> 
> This piece of the top-level Makefile in current git causes an
> out-of-tree driver Makefile to fail.
> 
> 101 ifdef O
> 102   ifeq ("$(origin O)", "command line")
> 103     KBUILD_OUTPUT := $(O)
> 104   endif
> 105 endif
> 
> The out-of-tree driver Makefile contains an O=... directive that
> (correctly) does _not_ specify the kernel source dir, and apparently
> isn't overridden by the command line either. If in the above Makefile
> snippet I change "command line" to "file", my out-of-tree make
> succeeds. What do you think about allowing O= to come from a file in
> addition to the command line?

When you change "command line" to "file" you actually makes kbuild
ignore the O=... value which is why it succeeds.
The problem we solve with the error below is that in some case
the Makefile for the kernel were overwritten.
And I do not really understand why this does not happen in yours
and Erik's case.

Anyway - the right fix seems to detect that the two directories
are equal and then just ignore the O=... setting.
But I am lacking time atm to fix it - only sparsely working on
Linux the next few weeks.

	Sam
