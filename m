Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762Ab0AVLWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0AVLWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726Ab0AVLWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:22:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:52341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0AVLWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:22:41 -0500
Date: Fri, 22 Jan 2010 09:22:31 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] perf tools: fix dc8d6ab typo prohibiting perf top
	symbol annotation
Message-ID: <20100122112231.GC1244@ghostprotocols.net>
References: <1264142379.8074.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264142379.8074.3.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 22, 2010 at 07:39:39AM +0100, Mike Galbraith escreveu:
> 
> perf tools: fix dc8d6ab typo prohibiting perf top symbol annotation
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 6f30fe1..af2e224 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1669,7 +1669,7 @@ do_kallsyms:
>  	free(kallsyms_allocated_filename);
>  
>  out_try_fixup:
> -	if (err > 0) {
> +	if (err <= 0) {
>  out_fixup:
>  		if (kallsyms_filename == NULL)
>  			dso__set_long_name(self, strdup("[kernel.kallsyms]"));

Strange, we need to fixup the map only if we found some symbol, so all
the routines there return the number of symbols found or -1 for errors,
investigating perf top symbol annotation now...

- Arnaldo
