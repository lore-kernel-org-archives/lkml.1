Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXFVDic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXFVDic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 23:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXFVDiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 23:38:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49637 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXFVDiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 23:38:23 -0400
Subject: Re: Linux Kernel include files
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: david@lang.hm, schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
In-Reply-To: <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 11:38:47 +0800
Message-Id: <1182483527.10524.31.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 01:38 +0200, Joerg Schilling wrote:
> The main problems are not really hard to fix......
> 
> -	Most problems eem to be related to the fact that Linux does not
> 	use C-99 based types in the kernel and the related type definitions 
> 	are not written in plain C. This is something that should be fixed
> 	with a source consolidation program or by defining aliases to 
> 	C-99 types in case the compiler is not GCC.


The argument has been made that the standard C99 types are _optional_,
and anything included from a C library's headers without _explicitly_
being included by the user shouldn't define those types.

Personally, I think that's a load of bollocks. And it certainly doesn't
apply to Linux-specific files like <linux/cdrom.h>, which are perfectly
entitled to use a C standard from last millennium, regardless of
namespace 'pollution' issues. That's why we continue to use the crappy
__u32 types. Can you be more specific about why this is a problem? Don't
we mostly define those crappy types using arch-specific knowledge, as
'int', 'long', etc?

> -	Other problems are caused by additional tag definitions that could
> 	be disabled in case of a non-GCC compile.

We mostly try to remove this from user-visible parts of exported
headers. Sometimes we just remove it altogether; other bits are stripped
at export time when you run 'make headers_install'. Again, can you be
more specific about the problem?

-- 
dwmw2

