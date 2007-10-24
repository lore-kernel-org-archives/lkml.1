Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbXJXPZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbXJXPZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXJXPZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:25:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbXJXPZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:25:41 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] fix "passing argument # of '__memcpy' discards qualifiers from pointer target type" warnings
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 24 Oct 2007 17:25:30 +0200
References: <9hPIG-7In-19@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Iki6s-0000g8-N2@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19PIN4q2Ewrp161WBZA5v45RRn6Rs5Ln9ReMeo
 pJ5HLDFeUsJjvX/ZRySBDmJrpUze7zK9JDTBLsexP6JhiWHSm7
 2PdPTtRHW5Ey9RTcGcKfw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Botón <mboton.lkml@gmail.com> wrote:

> This patch fixes the warnings "passing argument 1 of '__memcpy' discards
> qualifiers from pointer target type" and "passing argument 2 of '__memcpy'
> discards qualifiers from pointer target type" when compiling some files.
> 
> I don't really know if this is the best way but at least I don't get more
> warnings.

> +++ linux-2.6.24-rc1/fs/cifs/dir.c    2007-10-24 15:49:44.000000000 +0200
> @@ -585,6 +585,7 @@

> +     unsigned char *dstname = (unsigned char *)a->name;

> @@ -593,7 +594,7 @@

> -             memcpy((unsigned char *)a->name, b->name, a->len);
> +             memcpy(dstname, b->name, a->len);

This looks like a compiler bug. Get the gcc people to fix it.
-- 
Top 100 things you don't want the sysadmin to say:
20. ...and if we just swap these two disc controllers like _this_...

Friß, Spammer: wd@bse.7eggert.dyndns.org esmpv@zxw.7eggert.dyndns.org
