Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXK0A2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXK0A2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbXK0A2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:28:13 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:63035 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbXK0A2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:28:12 -0500
Message-ID: <474B61B4.9020309@student.ltu.se>
Date: Tue, 27 Nov 2007 01:15:48 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Moore, Robert" <robert.moore@intel.com>
CC: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] [ACPI] utilities/: Compliment va_start() with va_end().
References: <200711250205.34299.lenb@kernel.org> <B28E9812BAF6E2498B7EC5C427F293A403BCB8FA@orsmsx415.amr.corp.intel.com>
In-Reply-To: <B28E9812BAF6E2498B7EC5C427F293A403BCB8FA@orsmsx415.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Moore, Robert wrote:
> This is an interesting one to me.
>
> From various documentation:
>
> After all arguments have been retrieved, va_end resets the pointer to
> NULL.
>
> va_end
> Each invocation of va_start must be matched by a corresponding
> invocation of va_end in the same function. After the call va_end(ap) the
> variable ap is undefined. Multiple transversals of the list, each
> bracketed by va_start and va_end are possible. va_end may be a macro or
> a function.   
>
> Now, I'm all for defensive programming, but I don't really see the point
> of va_end when the list will be only traversed once.
>
>   
First off, I think it is a good idea to follow the documentation, which stated:
"va_end
Each invocation of va_start must be matched by a corresponding
invocation of va_end in the same function."

Then if it is not really needed, does it take up extra cycles?
"In practice, with most C compilers, calling |va_end| does nothing
and you do not really need to call it.  This is always true in the GNU C
compiler."[1]

Portability:
"But you might as well call |va_end| just in case your
program is someday compiled with a peculiar compiler."[2]
This argument is not as likely thou, but who knows? (Since I guess Intel's
compiler is included in the 'most C compilers')

>
> We don't set all local pointers to NULL at function exit, what is the
> point of doing it here?
>   
I think it is a good thing if the code follows the documentation, both 
for the person who tries
to understand the code (to see when the 'args' is no longer needed and 
not getting confused
by the absent of va_end(), after all, IMHO we should write the code how 
we want things to
work and let the compiler do the optimizations (it usually does a better 
job at it then we do))
and to automated searches (that is how I found this one).
> I suppose some implementation could allocate memory at va_start, but in
> practice, does this happen?
>   
Not sure what you mean.
> Bob
>
>   
cu
Richard Knutsson

[1] 
http://www.cs.utah.edu/dept/old/texinfo/glibc-manual-0.02/library_28.html
[2] The rest of [1]'s line.

