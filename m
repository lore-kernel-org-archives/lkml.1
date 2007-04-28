Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXD1NRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXD1NRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXD1NRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:17:36 -0400
Received: from alf.uib.no ([129.177.30.3]:50514 "EHLO alf.uib.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXD1NRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:17:34 -0400
X-Greylist: delayed 977 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 09:17:34 EDT
Message-ID: <463345DA.7010106@cbu.uib.no>
Date: Sat, 28 Apr 2007 15:02:18 +0200
From: =?ISO-8859-1?Q?Gisle_S=E6lensminde?= 
	<Gisle.Salensminde@bccs.uib.no>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: entropy of /dev/random vs. openssl rand
References: <20070428110652.GI13982@tatooine.rebelbase.local>
In-Reply-To: <20070428110652.GI13982@tatooine.rebelbase.local>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-checked-clean: by exiscan on alf
X-Scanner: 72f0619d9e40c430147a5af79c7d1a0d http://tjinfo.uib.no/virus.html
X-UiB-SpamFlag: Not scanned (1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt wrote:
> Hi,
>
> I need to create a moderate amount of v3 keys for loop-aes and wonder
> how/if the "openssl rand" implementation differs significantly from
> /dev/random concerning entropy.
>
> In case /dev/random and "openssl rand" are somewhat comparable, I
> would just use the latter to create the keys.
>
>   
Openssl actually uses /dev/urandom to generate random bytes on Linux and other systems that support it, possibly with some further filtering. On systems without a random device, a configuration file is used instead, since openssl is supposed to be compatible over a wide range of systems. Openssl rand should therefore be equivalent with the non-blocking /dev/urandom on Linux.

from openssl crypto/rand/rand_unix.c:

 /* Use a random entropy pool device. Linux, FreeBSD and OpenBSD
  * have this. Use /dev/urandom if you can as /dev/random may block
  * if it runs out of random entries.  */

> However, I certainly don't want to use a /dev/urandom look-alike.
>
>   

Whether the blocking behaviour of /dev/random is desirable is a matter of discussion. Some people argue that a periodically reseeded cryptographic-quality random number generator is as secure as a true random number generator for all practical purposes. It does then not make sense with a blocking generator like /dev/random. This view is much disputed, as can be seen if you read the archives of the Linux kernel mailing list. I personally can't think of any realistic scenario where /dev/random would make you safe while /dev/urandom would make you sorry. Some people seem to think differently, including you apparently  :-) , while the openssl people seem more concerned about the blocking behaviour of /dev/random. 

-Gisle


