Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZFDRH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZFDRH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZFDRHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:07:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45646 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZFDRHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:07:17 -0400
X-Auth-Info: irbSfgmkleowwX5wLtYzz9SPsBLJCdulMMyN8WCMMO0=
To: Sergei Poselenov <sposelenov@emcraft.com>
cc: linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] Re: 'make headers_check' failed to install headers to arbitrary location
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <20090604175536.2a1d0add@emcraft.com>
References: <4A0C3BFB.1010305@emcraft.com> <4A155B53.4040905@emcraft.com> <20090604175536.2a1d0add@emcraft.com>
Comments: In-reply-to Sergei Poselenov <sposelenov@emcraft.com>
   message dated "Thu, 04 Jun 2009 17:55:36 +0400."
Date: Thu, 04 Jun 2009 19:07:15 +0200
Message-Id: <20090604170715.98806832E416@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sergei,

In message <20090604175536.2a1d0add@emcraft.com> you wrote:
> 
> Here is another version of the patch which fixes
> the "Argument list too long" error for "make headers_check", used xargs
> to minimize the perl calls (thanks, Wolfgang).

Hm... but now we have a useless use of cat and a temp file.

> -      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
> -                  $(addprefix $(install)/, $(all-files));           \
> +# Headers list can be pretty long, xargs helps to avoid
> +# the "Argument list too long" error.
> +      cmd_check = rm -f hdrlist; touch hdrlist;                      \
> +                  for f in $(all-files); do                          \
> +                  echo "$(install)/$${f} " >> hdrlist; done;         \
> +                  cat hdrlist | xargs                                \
> +                  $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH); \
> +                  rm -f hdrlist;                                     \

Why not simply:

	for f in $(all-files); do
		echo "$(install)/$${f}"
	done | xargs $(PERL) ...

?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
A witty saying proves nothing, but saying  something  pointless  gets
people's attention.
