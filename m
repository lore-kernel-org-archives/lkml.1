Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZJFNBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZJFNBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZJFNBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:01:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbZJFNBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:01:45 -0400
Date: Tue, 6 Oct 2009 15:00:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
Message-ID: <20091006130059.GD15320@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-6-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254809398-8078-6-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

>  	OPT_BOOLEAN('v', "verbose", &verbose,
>  		    "be more verbose (show symbol address, etc)"),
> +	OPT_BOOLEAN('p', "perl", &do_perl,
> +		    "send output to a Perl script"),
>  	OPT_STRING('s', "script", &script_name, "file",
>  		    "script file name"),

I dont think we want to use up primary option letters one per language. 
If Perl takes 'p' then what will Python use, 'P'? How about PHP, PEARL 
and PostScript then? ;-)

I think it's better to make the language specification part of the 
-s/--script option, via two methods:

Explicit:

  -s Perl::my_script.pl
  -s pl::my_script.pl
  -s Python::my_script.py
  -s Bash::my_script.sh

Implicit, based on the script extension:

  -s my_script.pl       # maps to the Perl generator
  -s my_script.py       # maps to the Python generator
  -s my_script.sh       # maps to the Bash generator

I think we also want to have a 'perf -s *' kind of thing to get a list 
of all available language modules.

	Ingo
