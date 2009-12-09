Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZLIUcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZLIUcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZLIUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:32:07 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63828 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZLIUcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t49g9/hlPRMNaYFKgIQwGMaBsBql3djE21kr/IYuF91aNtkP9MI45ihsKVhv0JtOrT
         KNEH6iTfHAN+vbS6KtkhiHeKWw5hNXSiKhPWB3VTj/LZLv2wKOWr5qfMJRoIVp2W5oNL
         REeNzUx2DTD1VLrgCMM+eIOOpNdnHLpVV5/8M=
MIME-Version: 1.0
In-Reply-To: <20091209155903.GB3247@hack>
References: <1260360143-17093-1-git-send-email-vapier@gentoo.org> 
	<20091209155903.GB3247@hack>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 9 Dec 2009 15:31:52 -0500
Message-ID: <8bd0f97a0912091231l75e4cd13te3d073477455189@mail.gmail.com>
Subject: Re: [PATCH] modpost: fix asprintf warnings
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 10:59, Américo Wang wrote:
> On Wed, Dec 09, 2009 at 07:02:23AM -0500, Mike Frysinger wrote:
>>--- a/scripts/mod/modpost.c
>>+++ b/scripts/mod/modpost.c
>>@@ -1559,7 +1559,8 @@ static void get_markers(struct elf_info *info, struct module *mod)
>>                       const char *name = strings + sym->st_value;
>>                       const char *fmt = strchr(name, '\0') + 1;
>>                       char *line = NULL;
>>-                      asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
>>+                      if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
>>+                              fatal("asprintf() with %s failed", name);
>
> A '\n' is needed.

hmm, i thought fatal() appended a new line automatically.  must have
been thinking of one of the other utils.
-mike
