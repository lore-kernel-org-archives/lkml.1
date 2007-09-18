Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXIRTQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXIRTQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXIRTQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:16:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46241 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbXIRTQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:16:16 -0400
Date: Tue, 18 Sep 2007 21:17:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070918191741.GA27725@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miles.
On Tue, Sep 18, 2007 at 11:27:23AM -0400, Miles Lane wrote:
> Selecting Help for "Subarchitecture Type" causes "make menuconfig" to
> crash, and the bash display settings have to be reset.

Not reproduceable here.
But I noticed that we pass a null pointer to a vsprintf function which
in the cases you pointed out printed a (null) at my system.
Could you plase try if attached patch fix your system.

Thanks,
	Sam

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 2ee12a7..1935818 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -357,8 +357,9 @@ static void get_symbol_str(struct gstr *r, struct symbol *sym)
 	bool hit;
 	struct property *prop;
 
-	str_printf(r, "Symbol: %s [=%s]\n", sym->name,
-	                               sym_get_string_value(sym));
+	if (sym && sym->name)
+		str_printf(r, "Symbol: %s [=%s]\n", sym->name,
+		                                    sym_get_string_value(sym));
 	for_all_prompts(sym, prop)
 		get_prompt_str(r, prop);
 	hit = false;
