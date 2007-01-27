Return-Path: <linux-kernel-owner+w=401wt.eu-S1751699AbXA0MHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbXA0MHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 07:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXA0MHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 07:07:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:52456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXA0MHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 07:07:47 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 2/8] readahead: state based method routines: explicitly embed class_new/class_old inside flags
To: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>,
       Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 27 Jan 2007 13:01:08 +0100
References: <7HR6P-3Wm-3@gated-at.bofh.it> <7HR6S-3Wm-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HAmF2-0000cV-Ux@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1+ZKP137T4U2rmNxEYP/kJGRbgXxug6NP+jcw2uNHMouThLXZjMsf00yVTGj+zwi4j0B889o9TZoGlpHAmO2CGaYQH3rmOqC4JCCnpy3uLy0g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> The new/old ra class were implicitly stored in low bits of
> file_ra_state.flags. Now make the data structure obvious, and remove the
> coding tricks.

> +++ linux-2.6.20-rc4-mm1/include/linux/fs.h

> -     unsigned long flags;    /* RA_FLAG_xxx | ra_class_old | ra_class_new */
> +     union {
> +             unsigned long   flags;  /* RA_FLAG_xxx | class_old | class_new */
> +             struct {
> +                     u8      class_new;
> +                     u8      class_old;

This doesn't work on big endiam machines, does it?

IMO you should use a bitfield instead.
-- 
Your e-mail has been returned due to insufficient voltage. 

Friﬂ, Spammer: aegzcH4Js@luevh-7.7eggert.dyndns.org
 ptulV7@C.7eggert.dyndns.org vkIfyB@SEcltba.7eggert.dyndns.org
