Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0BAVGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:06:10 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63827 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0BAVGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:06:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/635wy0zdwv38RDh+3k9xO
Date: Mon, 1 Feb 2010 13:06:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: d binderman <dcb314@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: arch/arm/mach-omap2/mux.c: Off by one error
Message-ID: <20100201210633.GC22747@atomide.com>
References: <BLU108-W14539E61D58BF455B82CA59C590@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BLU108-W14539E61D58BF455B82CA59C590@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* d binderman <dcb314@hotmail.com> [100131 04:14]:
> 
> 
> Hello there,
> 
> I just ran the sourceforge tool cppcheck over the source code of the
> new Linux kernel 2.6.33-rc6
> 
> It said
> 
> [./arm/mach-omap2/mux.c:492]: (error) Buffer access out-of-bounds
> 
> The source code is
> 
>         char mode[14];
>         int i = -1;
> 
>         sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);
> 
> 13 characters + 1 digit + 1 zero byte is more than 14 characters.
> 
> Suggest new code
> 
>         char mode[15];
>         int i = -1;
> 
>         sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);

Thanks for reporting this.

I'll queue up the following fix for this for 2.6.34.

Regards,

Tony

From: Tony Lindgren <tony@atomide.com>
Date: Mon, 1 Feb 2010 13:03:42 -0800
Subject: [PATCH] omap: Fix arch/arm/mach-omap2/mux.c: Off by one error

David Binderman ran the sourceforge tool cppcheck over the source code of the
new Linux kernel 2.6.33-rc6:

[./arm/mach-omap2/mux.c:492]: (error) Buffer access out-of-bounds

13 characters + 1 digit + 1 zero byte is more than 14 characters.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 32764be..047aa57 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -486,7 +486,7 @@ int __init omap_mux_init_signal(char *muxname, int val)
 static inline void omap_mux_decode(struct seq_file *s, u16 val)
 {
 	char *flags[OMAP_MUX_MAX_NR_FLAGS];
-	char mode[14];
+	char mode[15];
 	int i = -1;
 
 	sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);
