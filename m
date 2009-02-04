Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbZBDSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbZBDSbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZBDSbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:31:44 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44873 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbZBDSbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:31:43 -0500
Date: Wed, 4 Feb 2009 13:31:42 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: Missing unistd_no.h and unistd_mm.h export on m68k
Message-ID: <20090204183142.GF26064@csclub.uwaterloo.ca>
References: <20090204181453.GE26064@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204181453.GE26064@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 01:14:53PM -0500, Lennart Sorensen wrote:
> make header_install fails to include the files unistd_no.h and
> unistd_mm.h on m68k, while those two files are included by unistd.h.
> 
> This patch fixes this by adding these two files to the list of m68k
> specific headers to export.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> 
> Signed
> diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> index 1a922fa..2bb4738 100644
> --- a/arch/m68k/include/asm/Kbuild
> +++ b/arch/m68k/include/asm/Kbuild
> @@ -1,2 +1,2 @@
>  include include/asm-generic/Kbuild.asm
> -header-y += cachectl.h
> +header-y += cachectl.h unistd_no.h unistd_mm.h

Hmm, seems it is actually much worse than I thought.  All _no.h and
_mm.h are being missed, making m68k compiles of things like uclibc
rather broken.  Yuck.

-- 
Len Sorensen
