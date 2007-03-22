Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXCVE7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXCVE7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933151AbXCVE7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:59:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:19317 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbXCVE7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:59:33 -0400
Message-ID: <d4cf37a60703212159u54fe7fdehf052c1cc788b9b94@mail.gmail.com>
Date: Wed, 21 Mar 2007 21:59:33 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Initial implementation of the trec driver and include files
In-Reply-To: <20070321181739.GC16768@leiferikson>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com>
	 <20070321082238.GA16768@leiferikson> <46016208.3040303@saville.com>
	 <20070321181739.GC16768@leiferikson>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Johannes Weiner <hannes-kernel@saeurebad.de> wrote:
> Hi,
>
> On Wed, Mar 21, 2007 at 09:49:12AM -0700, Wink Saville wrote:
> > >>Please don't use camel-case - in general.
> > >>
> > Would p_next, p_cur and p_end be OK?
>
> I think it's generally disliked. Quoting Documentation/CodingStyle:
>
> ``Encoding the type of a function into the name (so-called Hungarian
> notation) is brain damaged - the compiler knows the types anyway and can
> check those, and it only confuses the programmer.  No wonder MicroSoft
> makes buggy programs.''
>

I'll change it to; next, cur, end (when in rome do as the romans)

>
> You can implement a sysctl-setting to enable/disable the whole system
> (which then would be runtime changeable).

Generally the way I've used this in the kernel is sprinkle them liberally
where I'm trying to track down a bug or understand how some code works
and then disable some of them using ZREC's but then reenable as
necessary. Finally, I remove them all usually by reverting to the original
code.

In userland I have a more sophisticated version which combines TREC's
and printf's in one macro with a "debug variable" defined as a
set of bits controlling the enable/disable sets of these. For example:

   DPRP1(1 << 2, "This is a DPR with parameter=%d", xyz);

#define DPRP1(__bits, __format, __param, ...) \
do { \
   if (((__bits) << 16) & dbg_variable) \
         printf((__format), __param...); \
   if ((__bits) & dbg_variable) \
         TREC1((__param)); \
} while (0)

The above divides "dbg_variable" into 2 16 bit fields, the upper 16
bits control if the printf is enabled and the lower 16 bits controls if
the TREC1 is enabled. What I envision happening would possibly
to expose the "dbg_variable" via procfs where it could "easily" be
modified from userland.

Anyway, for my immediate needs I just needed the TREC's so I could
understand the inner workings of the kernel better and assist in debugging.
I've submitted it as a patch incase anyone might be interested.

Actually, are you interested in using them?

In anycase thanks for the feed back.

Wink
