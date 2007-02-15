Return-Path: <linux-kernel-owner+w=401wt.eu-S1161399AbXBOVcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161399AbXBOVcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161398AbXBOVcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:32:04 -0500
Received: from neon.samage.net ([83.149.67.130]:56674 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161399AbXBOVcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:32:01 -0500
Message-ID: <1715.81.207.0.53.1171575112.squirrel@secure.samage.net>
In-Reply-To: <7291.1171482057@redhat.com>
References: <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org>
    <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
    <7291.1171482057@redhat.com>
Date: Thu, 15 Feb 2007 22:31:52 +0100 (CET)
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
From: "Indan Zupancic" <indan@nul.nu>
To: "David Howells" <dhowells@redhat.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7
X-Scan-Signature: 8b3222cd26cce149ddb9ffa05c4da76e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, February 14, 2007 20:40, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> >  (1) A cut-down MPI library derived from GPG with error handling added.
>>
>> Do we really need to add this?
>
> I presume you mean the MPI library specifically?  If so, then yes.  It's
> necessary to do DSA signature verification (or RSA for that matter).
>
>> Wouldn't it be much nicer to just teach people to use one of the existing
>> signature things that we need for _other_ cases anyway, and already have
>> merged?
>
> Existing signature things?  I know not of such beasts, nor can I see them
> offhand.

The question is if using DSA/RSA is the right choice for something like this.
I think that the symmetrically encrypted hash output as signature would provide
the same amount of security. The only additional requirement is that the key
can't be read by userspace. But if they can reach the kernel binary, they can
modify it too. Same for the bootloader, where you'd want the key and initial
checking anyway. Else this whole thing could be done in user space as Roman
Zippel said...

The ELF section stuff seems like unnecessary bloat too. Can't you use/extend
modinfo, or kernel symbols?

With the above changes the code should shrink to only a few hundred new lines
of code, instead of thousands, and signature checking will be much faster too.

Greetings,

Indan


