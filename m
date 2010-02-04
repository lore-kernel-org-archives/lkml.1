Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0BDGb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:31:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:40280 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753186Ab0BDGbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:31:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xAV52TFrxTT8UN6WAd2tv9ZIlhmmhkknmdDTaTS
	KsN4YL7ugZDAI9
Subject: Re: [PATCH 8/9] perf annotate: fix it for non-prelinked *.so
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1265223128-11786-8-git-send-email-acme@infradead.org>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
	 <1265223128-11786-8-git-send-email-acme@infradead.org>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 07:31:46 +0100
Message-Id: <1265265106.6364.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 16:52 -0200, Arnaldo Carvalho de Melo wrote:
>  		const char *path = NULL;
> @@ -397,7 +397,8 @@ static void annotate_sym(struct hist_entry *he)
>  		       dso, dso->long_name, sym, sym->name);
>  
>  	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s",
> -		map->unmap_ip(map, sym->start), map->unmap_ip(map, sym->end),
> +		map__rip_2objdump(map, sym->start),
> +		map__rip_2objdump(map, sym->end),
>  		filename, filename);
>  

Monkey see monkey do.

perf tools: fix perf top module symbol annotation.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-top.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -204,8 +204,8 @@ static void parse_source(struct sym_entr
 	sprintf(command,
 		"objdump --start-address=0x%016Lx "
 			 "--stop-address=0x%016Lx -dS %s",
-		map->unmap_ip(map, sym->start),
-		map->unmap_ip(map, sym->end), path);
+		map__rip_2objdump(map, sym->start),
+		map__rip_2objdump(map, sym->end), path);
 
 	file = popen(command, "r");
 	if (!file)


