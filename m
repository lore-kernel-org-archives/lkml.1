Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbXHQTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbXHQTwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbXHQTwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:52:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:43225 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXHQTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NhMhSPzWYr6/gEeWTtBRUwP9Gzp4TeFOcajPNWLYktqiGbK8dPNGMnHB30zeWY72NkU+ONI8qJLXbgf+5WouRtqupFZdjOxgmQICHoWo1Uh3nvgUI2d1tzRNs2zgwoKuF8WFngC0i2lccdvASd2xZCerLpNhVlZE2rgnzRyM5Rs=
Message-ID: <9a8748490708171252n5653d879j309328504e31c338@mail.gmail.com>
Date: Fri, 17 Aug 2007 21:52:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: SVr4/SVID/SUS IPC conformance
Cc: "Anton Arapov" <aarapov@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1187376971.2615.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <h8ps1mm64v.fsf@pepelac.englab.brq.redhat.com>
	 <1187376971.2615.4.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/07, Arjan van de Ven <arjan@infradead.org> wrote:
>
> On Fri, 2007-08-17 at 19:18 +0200, Anton Arapov wrote:
> >
> >   IPC code is good, EIDRM is justification of EINVAL. But neither SVr4 nor SVID \
> > documents EIDRM.   Single Unix Specification mentions EINVAL but not EIDRM as a \
> > possible failure for shmctl(), so the current kernel behavior is not merely \
> > self-inconsistent but a flat violation of the spec.
>
> these specs tend to always allow additional error codes.
>
I can't seem to find anything in SuS v3 that says that. If you know
where I'd appreciate a pointer.
In fact, the spec seems pretty clear on what errors are OK.


"
    The shmctl() function shall fail if:

    [EACCES]
        The argument cmd is equal to IPC_STAT and the calling process
does not have read permission; see XSI Interprocess Communication.
    [EINVAL]
        The value of shmid is not a valid shared memory identifier, or
the value of cmd is not a valid command.
    [EPERM]
        The argument cmd is equal to IPC_RMID or IPC_SET and the
effective user ID of the calling process is not equal to that of a
process with appropriate privileges and it is not equal to the value
of shm_perm.cuid or shm_perm.uid in the data structure associated with
shmid.

    The shmctl() function may fail if:

    [EOVERFLOW]
        The cmd argument is IPC_STAT and the gid or uid value is too
large to be stored in the structure pointed to by the buf argument.
"


But I guess removing EIDRM is out of the question since that would
break userspace applications currently depending on it.
So I guess that the only way to write applications that are portable
between Linux and other *NIX clones is to test for the error code
being  (EINVAL || EIDRM)...

Or am I missing something?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
