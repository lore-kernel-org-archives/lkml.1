Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZLSV7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZLSV7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZLSV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:59:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:47735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZLSV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:59:47 -0500
Subject: Re: [PATCH 1/1 v2] perf record: We should fork only if a program
 was specified to run
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1261257771-10263-1-git-send-email-acme@infradead.org>
References: <1261257771-10263-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Dec 2009 22:59:04 +0100
Message-ID: <1261259944.4314.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-19 at 19:22 -0200, Arnaldo Carvalho de Melo wrote:
> @@ -422,7 +423,7 @@ static int __cmd_record(int argc __used, const char **argv)
>         signal(SIGCHLD, sig_handler);
>         signal(SIGINT, sig_handler);
>  
> -       if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
> +       if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
>                 perror("failed to create pipes");
>                 exit(-1);
>         } 

you can avoid this by simply putting the whole thing into the if (forks)
thing below.

