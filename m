Return-Path: <linux-kernel-owner+w=401wt.eu-S1763088AbXERGye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763088AbXERGye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762381AbXERGyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:54:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59604 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762195AbXERGyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:54:14 -0400
Date: Fri, 18 May 2007 08:52:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 01/14] kbuild: make modpost section warnings clearer
In-Reply-To: <20070518064918.GA12284@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0705180851200.3231@yvahk01.tjqt.qr>
References: <20070518064126.GA12193@uranus.ravnborg.org>
 <20070518064918.GA12284@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 08:49, Sam Ravnborg wrote:
>index 113dc77..acd28ab 100644
>--- a/scripts/mod/modpost.c
>+++ b/scripts/mod/modpost.c
>@@ -885,29 +885,28 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
> 		return;
> 
> 	if (before && after) {
>-		warn("%s - Section mismatch: reference to %s:%s from %s "
>-		     "between '%s' (at offset 0x%llx) and '%s'\n",
>-		     modname, secname, refsymname, fromsec,
>+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
>+		     "(between '%s' and '%s')\n",
>+		     modname, fromsec, (long long)r.r_offset,
>+		     secname, refsymname,

%x always takes unsigned. %llx => (unsigned long long)r.r_offset.
Ditto below.

> 		     elf->strtab + before->st_name,
>-		     (long long)r.r_offset,
> 		     elf->strtab + after->st_name);
> 	} else if (before) {
>-		warn("%s - Section mismatch: reference to %s:%s from %s "
>-		     "after '%s' (at offset 0x%llx)\n",
>-		     modname, secname, refsymname, fromsec,
>-		     elf->strtab + before->st_name,
>-		     (long long)r.r_offset);
>+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
>+		     "(after '%s')\n",
>+		     modname, fromsec, (long long)r.r_offset,
>+		     secname, refsymname,
>+		     elf->strtab + before->st_name);
[more occurences]


	Jan
-- 
