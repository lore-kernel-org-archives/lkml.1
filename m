Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZLNLVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZLNLVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZLNLVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:21:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40112 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbZLNLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VW2EjQPXcpiRRDS9/Rt67Jy/HTwCJ0PL9smIxoJv6of85lKwGVaLl6XWnptMYKGASI
         6hy9F7L7tXZcefkwtigLAIMEFZfXwhJgd466CvOInOVWexd7SQPRgNQpOX70WfxTGVG1
         RYe2OjCx2JbxVo20h9u8UlXLif4xFyFurHzCg=
Date: Mon, 14 Dec 2009 12:21:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf symbols: Allow lookups by symbol name too
Message-ID: <20091214112132.GD5168@nowhere>
References: <1260564622-12392-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260564622-12392-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 06:50:22PM -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Configurable via symbol_conf.sort_by_name, so that the cost of an extra
> rb_node on all 'struct symbol' instances is not paid by tools that only
> want to decode addresses.
> 
> How to use it:
> 
> 	symbol_conf.sort_by_name = true;
> 	symbol_init(&symbol_conf);
> 
> 	struct map *map = map_groups__find_by_name(kmaps, MAP__VARIABLE, "[kernel.kallsyms]");
> 
> 	if (map == NULL) {
> 		pr_err("couldn't find map!\n");
> 		kernel_maps__fprintf(stdout);
> 	} else {
> 		struct symbol *sym = map__find_symbol_by_name(map, sym_filter, NULL);
> 		if (sym == NULL)
> 			pr_err("couldn't find symbol %s!\n", sym_filter);
> 		else
> 			pr_info("symbol %s: %#Lx-%#Lx \n", sym_filter, sym->start, sym->end);
> 	}
> 
> Looking over the vmlinux/kallsyms is common enough that I'll add a
> variable to the upcoming struct perf_session to avoid the need to use
> map_groups__find_by_name to get the main vmlinux/kallsyms map.
> 
> The above example looks on the 'variable' symtab, but it is just like
> that for the functions one.
> 
> Also the sort operation is done when we first use
> map__find_symbol_by_name, in a lazy way.



Thanks a lot. I'll give it a try soon :)

