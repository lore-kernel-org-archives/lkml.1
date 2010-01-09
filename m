Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380Ab0AIAKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0AIAKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:10:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058Ab0AIAKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:10:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab0AIAKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:10:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: strict copy_from_user checks issues?
Date: Sat, 9 Jan 2010 01:07:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001071502.29777.arnd@arndb.de> <4B4674FF.5070700@zytor.com>
In-Reply-To: <4B4674FF.5070700@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001090107.43402.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18W5VGwLf3OUOOx/KMHqa2T3D0TVZzSD3YzTbV
 ac7N1eQUvbKpxK9lXTvUKrteINDqk0dCSfoQ+dGLsWGptttwOC
 uA3wb95IzZE48Dua26rLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 January 2010 00:57:51 H. Peter Anvin wrote:
> On 01/07/2010 06:02 AM, Arnd Bergmann wrote:
>
> > On a related topic, one interface that may actually be worth adding is
> > a get_user/put_user variant that can operate on full data structures
> > and return -EFAULT on failure rather than the number of remaining
> > bytes that 99% of the code never need.
> 
> What is wrong with checking for zero?

It's counterintuitive. Everyone who is around long enough should know about
the copy_from_user calling conventions, but the fact that Arjan submitted
a patch returning EFAULT from copy_from_user and Ingo and Dave both added
this to their trees tells me that it's less than ideal.

Also, the calling conventions require you to write slightly more when
you want to pass down an error value, e.g.

	return copy_to_user(uptr, &data, sizeof(data)) ? -EFAULT : 0;

instead of

	return put_user(data, uptr);

The latter form requires a macro instead of a function for the user copy,
but we now have that anyway because of the size check.

	Arnd
