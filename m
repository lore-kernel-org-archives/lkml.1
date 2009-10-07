Return-Path: <linux-kernel-owner+w=401wt.eu-S1751223AbZJGES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbZJGES1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZJGES0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:18:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:51421 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZJGESZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ETKJwVk6Imdjg8LFGNsxtIlJjXsHEFUOtrPFo7p8pxCGpYkD7CAjPiYCldDaRZpZoJ
         mUBHpTBAPLn4YjXst77Vq2fBpSbiNb5bnHsfMUS6Fkg9fVskLZc5URhMKqmI0pDAuNbg
         2GnLW4WIHsCgRAE+asuYmKFSOx8V1GfuAaQfY=
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
In-Reply-To: <20091006130059.GD15320@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
	 <1254809398-8078-6-git-send-email-tzanussi@gmail.com>
	 <20091006130059.GD15320@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 23:09:25 -0500
Message-Id: <1254888565.28917.135.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 15:00 +0200, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> >  	OPT_BOOLEAN('v', "verbose", &verbose,
> >  		    "be more verbose (show symbol address, etc)"),
> > +	OPT_BOOLEAN('p', "perl", &do_perl,
> > +		    "send output to a Perl script"),
> >  	OPT_STRING('s', "script", &script_name, "file",
> >  		    "script file name"),
> 
> I dont think we want to use up primary option letters one per language. 
> If Perl takes 'p' then what will Python use, 'P'? How about PHP, PEARL 
> and PostScript then? ;-)
> 
> I think it's better to make the language specification part of the 
> -s/--script option, via two methods:
> 
> Explicit:
> 
>   -s Perl::my_script.pl
>   -s pl::my_script.pl
>   -s Python::my_script.py
>   -s Bash::my_script.sh
> 
> Implicit, based on the script extension:
> 
>   -s my_script.pl       # maps to the Perl generator
>   -s my_script.py       # maps to the Python generator
>   -s my_script.sh       # maps to the Bash generator
> 
> I think we also want to have a 'perf -s *' kind of thing to get a list 
> of all available language modules.
> 

I knew somebody would point that out (and suggest a better way ;-)  That
all makes sense - I'll make these changes in the next version.

Tom


> 	Ingo

