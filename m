Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXE3WgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXE3WgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXE3WgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:36:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:62401 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXE3WgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Av9PEqVZbW98l12aNOr3neuq4G5n/9unMhMH6Hv8SsT45cqm4qVnfOVjnAgPetzcqTOgXWk+PVZfCIJ1tUPQdPtr2vFuSxcllCxiNzMfhQ+RpJwKp3xqD8fke8yjvUJm8sSgBTzldH9Kx+kycrNmdukU8+yfU/7EXVZmAD+vJo8=
Message-ID: <9a8748490705301536p7c4d2918u1ee4ae1b6ec268f4@mail.gmail.com>
Date: Thu, 31 May 2007 00:36:14 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/3] hexdump: more output formatting
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hugh@veritas.com
In-Reply-To: <20070530143428.2f20446a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	 <20070524073131.GA17501@elte.hu>
	 <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	 <20070524142908.f39f42ea.akpm@linux-foundation.org>
	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
	 <20070530143428.2f20446a.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>

Some friendly nitpicking below :-)

> Add a prefix string parameter.  Callers are responsible for any
> string length/alignment that they want to see in the output.  I.e.,
> callers should pad strings to achieve alignment if they want that.
>
> Add rowsize parameter.  This is the number of raw data bytes
> to be printed per line.  Must be 16 or 32.
>
> Add a group_size parameter.  This allows callers to dump values

One is called "rowsize" the other "group_size". How about consistent
naming; either "row_size" and "group_size" or "rowsize" and
"groupsize" ?

> as 1-byte, 2-byte, 4-byte, or 8-byte numbers.  Default is
> 1-byte numbers.  If the total length is not an even multiple
> of group_size, 1-byte numbers are printed.
>
> Add an "ascii" output parameter.  This causes ASCII data output
> following the hex data output.
>
> Clean up some doc examples.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
[snip]
> +
> +       switch (group_size) {
> +       case 8: {
> +               const u64 *ptr8 = buf;
> +               int ngroups = len / group_size;
> +
> +               for (j = 0; j < ngroups; j++)
> +                       lx += scnprintf(linebuf + lx, linebuflen - lx,
> +                               "%16.16llx ", (unsigned long long)*(ptr8 + j));
> +               break;
> +       }
> +

I don't see the point in this (and the other) extra blank lines
between closing brace of one case and the start of the next. Removing
the blank line wouldn't hurt readability but would allow more lines of
code to be visible on the screen at once.

> +       case 4: {

[snip]


Apart from those nits, nice patch, nice improvement.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
