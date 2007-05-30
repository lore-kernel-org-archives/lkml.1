Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbXE3V4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbXE3V4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXE3V4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:56:36 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:12072 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXE3V4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dyrFA3aCtCNWQDOAT65Pb9ufavHA/YK6uOqCyz1R0NOZTZ4v8qPiO96Nxgonjor/LKrIUG5ePOU752xaIwiOYGfzFGLXLZd6smmAGYAb/2qCPvBjJDX1WabSJRzGsSEeS/ZlJDYrUEuZMQq7neqp15jpdpcpKbH8FP2r+pns6q8=
Message-ID: <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com>
Date: Thu, 31 May 2007 03:26:31 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
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

Hello Randy,

> Add a prefix string parameter.  Callers are responsible for any
> string length/alignment that they want to see in the output.  I.e.,
> callers should pad strings to achieve alignment if they want that.
>
> Add rowsize parameter.  This is the number of raw data bytes
> to be printed per line.  Must be 16 or 32.
>
> Add a group_size parameter.  This allows callers to dump values
> as 1-byte, 2-byte, 4-byte, or 8-byte numbers.  Default is
> 1-byte numbers.  If the total length is not an even multiple
> of group_size, 1-byte numbers are printed.

I wonder if (over-)engineering could hurt its adoption by more kernel
users. There aren't very many 8-argument monsters in the kernel,
and one would expect hexdump() to be easier on the fingers to
type? :-) Why not just continue with reasonable default/fixed rowsize
and groupsize values?

> Add an "ascii" output parameter.  This causes ASCII data output
> following the hex data output.
[...]
> +       if (!ascii)
> +               goto nil;
> +
> +       if ((lx + 1) < linebuflen)
>                 linebuf[lx++] = ' ';
> -       }
> -       for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
> +       for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
>                 linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
> +nil:
>         linebuf[lx++] = '\0';

if (ascii) {
...
}

linebuf[lx++] = '\0';

would help lose a goto and label.

Satyam
