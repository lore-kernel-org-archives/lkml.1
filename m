Return-Path: <linux-kernel-owner+w=401wt.eu-S1945890AbXBVBdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945890AbXBVBdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945934AbXBVBdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:33:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:32197 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945890AbXBVBdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZtShZi2oy22uufubtTEzNC91uybI/rjamePA62DWxRZ/lyINk7I8TVxNGjBXKtd/kdjhDCDipormzDS4XfMCE6K2PdtEJIWaS3t8hmti9a6e1g+fo0kjgFQbg+U/s9vh7jyaXul32JwQiyGc6r9ayKz1WQxo8t55EdZ/D45bFhQ=
Message-ID: <f2b55d220702211733l336a5bc9r10e69abc4f0afca6@mail.gmail.com>
Date: Wed, 21 Feb 2007 17:33:05 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221225711.GB32031@elte.hu>
	 <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Michael K. Edwards <medwards.linux@gmail.com> wrote:
> You won't be able to do it later if you don't design for it now.
> Don't reinvent the square wheel -- there's a model to follow that was
> so successful that it has killed all alternate models in its sphere.
> Namely, IEEE 754.  But please try not to make pipeline flushes suck as
> much as they did on the i860.

To understand why I harp on IEEE 754 as a sane model for pipelined
AIO, you might consider reading (at least parts of):
    http://www.cs.berkeley.edu/~wkahan/JAVAhurt.pdf

People who write industrial-strength floating point programs rely on
the IEEE floating point semantics to avoid having to check every
result of every arithmetic step to see whether it is a valid input to
the next step.  NaNs and +/-0 and overflows and all that jazz are
essential to efficient coding of things like matrix inversion, because
the only alternative is simply to fail.  But in-line indications of an
exceptional result aren't enough, because it may or may not have been
a coding error, and you may need fine-grained control over which
"failure conditions" are within the realm of the expected and which
are not.

Here's a quotable bit from Kahan and Darcy's polemic:
<quote>
To achieve Floating-Point Predictability:
     Limit programmers' choices to what is reasonable and necessary as
well as parsimonious, and
     Limit language implementors'choices so as always to honor the
programmer's choices.
To do so, language designers must understand floating-point well
enough to validate their determination of "what is reasonable and
necessary," or else must entrust that determination to someone else
with the necessary competency.
</quote>

Now I ain't that "someone else", when it comes to AIO pipelining.  But
they're out there.  Figure out how to create an AIO model that honors
the RDBMS programmer's choices efficiently on a NUMA box without
making him understand NUMA, and you really will have created something
for the ages.

Cheers,
- Michael
