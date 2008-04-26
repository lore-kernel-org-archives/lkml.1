Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYDZS0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYDZS0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYDZS0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:26:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45780 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYDZS0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:26:16 -0400
Date: Sat, 26 Apr 2008 20:26:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header file
Message-ID: <20080426182648.GA18578@uranus.ravnborg.org>
References: <20080426134554.GA20727@damson.getinternet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426134554.GA20727@damson.getinternet.no>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
> Hi Sam,
> 
> Maybe something like this could be useful for cleaning up headers (and
> maintaining that cleanliness once it has been achieved). What do you think?
Hi Vegard.

I really like the idea to use some automated checks to increase the
quality of our headers.
And that raises the question about what is the most important
issue we have with our headers and how do we detect them in the
best possible way?

To detect inclusion cycles in a configured kernel I really think
sparse is the better place to detect it. We have sparse as an
advenced sanity check tool and adding the possibility to detect
inclusion cycles should be easier than it was to cook up this
perl script.

But we have much more important issues.
In general we have far to many dependencies in the current headers
and too much code rely on headers being implicitly pulled.

We have headers that uses types we actually do not want to use
in the kernel.

We have headers that export stuff to userspace they shouldnt.

We have heders defining prototypes for non existing functions.

We have headers defining extern variables that no longer exists.

You could continue the list.
And some of the above topics are really newbies material to fix.

If you then decide to automate it then I would need a good
explanation why we did not use sparse before considering
including the tool in the kernel.

So I do not plan to apply this patch because this should be
done in sparse and not in a random perl script.

> 
> (One thing which might or might not be good is that 'make headerdep' will
>  also compile using CC if they're not already compiled. If this should be
>  fixed, I think you'd know how to do it.)

Not a big deal - we neither support this for sparse.


> +# Output dependency graph in GraphViz language.
> +sub graph {
> +	printf "digraph {\n";
> +
> +	printf "\t/* vertices */\n";
> +	for my $header (keys %deps) {
> +		printf "\t%s [label=\"%s\"];\n",
> +			mangle($header), escape($header);
> +	}
> +
> +	printf "\n";
> +
> +	printf "\t/* edges */\n";
> +	for my $header (keys %deps) {
> +		for my $dep (@{$deps{$header}}) {
> +			printf "\t%s -> %s;\n",
> +				mangle($header), mangle($dep);
> +		}
> +	}
> +
> +	printf "}\n";
> +}

I like this part. I would be nice to see a full dependency graph
for any file that kbuild builds.
But again maybe we should do this as a sparse backend?

	Sam
