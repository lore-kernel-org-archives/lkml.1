Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZAYSCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZAYSCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 13:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZAYSCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 13:02:24 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35198 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZAYSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 13:02:23 -0500
Date: Sun, 25 Jan 2009 19:02:21 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Steve Brokenshire <sbrokenshire@xestia.co.uk>
cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
In-Reply-To: <20090125165118.dfdd3978.sbrokenshire@xestia.co.uk>
Message-ID: <alpine.LSU.2.00.0901251900490.7363@fbirervta.pbzchgretzou.qr>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org> <20090120033047.7412d93e.sbrokenshire@xestia.co.uk>
 <20090125165118.dfdd3978.sbrokenshire@xestia.co.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-01-25 17:51, Steve Brokenshire wrote:
>+
>+quiet_cmd_modules_install = INSTALL  $@
>+      cmd_modules_install = mkdir -p $(2); \
>+				cp $@ $(2) ; \
>+				$(mod_strip_cmd) $(2)/$(notdir $@)
>+
>+quiet_cmd_modules_compress_gzip = COMPRESS $@
>+      cmd_modules_compress_gzip = gzip $(MODCOMPOPT) -c \
>+				 $(2)/`basename $@` \
>+				 > $(2)/`basename $@`.gz; \
>+				 rm $(2)/`basename $@`

That is *three* extra shell invocations you got there
for something make can compute itself using $(@F) iirc.
