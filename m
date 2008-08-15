Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYHORN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYHORN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYHORNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:13:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:64809 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYHORNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tmpxxAhBoVoIqDK1jhhsgbkbeLCzczgpwqQ7I+JAyResn8ubqLIDg++Wsr6xCWjTx9
         SXnVuclRCICgCvkGkOd+kfx4lsOs8yDGBn3dFzI/kKo2l8TKvLIlyEOM+2nCeiGD0r/H
         K2Xu9yglLUSI2B3UwWdxSOcEIsQXdmBRaReog=
Message-ID: <48A5B943.1010607@gmail.com>
Date: Fri, 15 Aug 2008 10:13:39 -0700
From: Ulrich Drepper <drepper@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       akpm@linux-foundation.org, hugh@veritas.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, briangrant@google.com, cgd@google.com,
       mbligh@google.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
References: <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com> <20080813160218.GB18037@elte.hu> <20080815155457.GA5210@shareable.org>
In-Reply-To: <20080815155457.GA5210@shareable.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jamie Lokier wrote:
> Suggest:
> 
> +#define MAP_STACK       0x20000         /* 31bit or 64bit address for stack, */
> +                                        /* whichever is faster on this CPU */

I agree.  Except for the comment.


> Also, is this _only_ useful for thread stacks, or are there other
> memory allocations where 31-bitness affects execution speed on old P4s?

Actually, I would define the flag as "do whatever is best assuming the
allocation is used for stacks".

For instance, minimally the /proc/*/maps output could show "[user
stack]" or something like this.  For security, perhaps, setting of
PROC_EXEC can be prevented.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkiluUMACgkQ2ijCOnn/RHSb5gCfb5VhiLA/wbamoAVqfxR32k4N
tSIAoK/KAmwcVd+RjkPnb9RSuAeL/KLV
=2ynl
-----END PGP SIGNATURE-----
