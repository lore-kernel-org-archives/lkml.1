Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbYEGTV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbYEGTV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764884AbYEGTVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:21:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:24071 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765826AbYEGTVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GChDZnUJi+oyc+d4jOo25wBp9w9PGA+ofaUmwCLgF2RxCHLhCYalJ0ZyLnQWN+2aykg+61MlUptKCjI1F2J+lMBob82yvxuKVlWjd6jd4LJe+J5tH1/LbVBfo8QtL4I5fPqzB1TBXPkutwRZkoGS25tztgfI/VZ9NumI8Obps+8=
Subject: Re: [PATCH 2/2] lib: vsprintf.c remove macros defining strict
	string functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080507200909.GB5131@martell.zuzino.mipt.ru>
References: <1210184729.19279.33.camel@brick>
	 <20080507200909.GB5131@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Wed, 07 May 2008 12:20:46 -0700
Message-Id: <1210188046.19279.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 00:09 +0400, Alexey Dobriyan wrote:
> On Wed, May 07, 2008 at 11:25:29AM -0700, Harvey Harrison wrote:
> > Directly code the strict string conversion functions rather than using
> > defining macros.  Pull out a small helper to check the strict conditions
> > required at the end of a string (nul-terminated or newline).
> 
> > Add additional checks in strict_strtol and strict_strtoll for numeric
> > overflow of the signed types.
> 
> C interer ranges are asymmetric.

Yes, and LLONG_MAX = -LLONG_MIN + 1...so it will reject string values
of LLONG_MIN...easily fixed if we want it I guess.

> 
> These "strict_" functions are a farce. No amount of afterchecking will
> save you if there is trivial wraparound in core function.
> 

That's also true, I guess it depends on how far we want to go.  And
after that point, just stick a WARN_ON and return -EINVAL.

I'm not sure where the balance is, but I think my patch is still on
the useful side of it.

> 	Alexey "kstrtonum" Dobriyan
> 
> > + */
> > +static int strict_checktail(size_t len, const char *cp, const char *tail)
> 
> Name simply sucks.

Sure does, care to suggest something better, at least it had a
comment ;-)

Anyways, thanks for taking a look.

Harvey

