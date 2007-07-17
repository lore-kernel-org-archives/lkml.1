Return-Path: <linux-kernel-owner+w=401wt.eu-S1765636AbXGQLjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765636AbXGQLjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXGQLjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:39:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:24467 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbXGQLjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rb2+g5fqLFThBpgUEdEnyhjyrBjAHSz0+F7hkITbLuaJikETQ+IGeyvaTdDTxkBeIV5RrXJ0AyUXNO3n0nITaNFkvShRNirplLEC/l4+8e3Qf3TXUaJsm1I1zbmJy2cJnOjPP1cVdwNZNpplxZMEEMbj5xImJOsyRW+mXpXTLPs=
Message-ID: <9a8748490707170439y5f9f2a54s98c02f31d9dae86@mail.gmail.com>
Date: Tue, 17 Jul 2007 13:39:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Ingo Freund" <linux-kernel-news@e-dict.net>
Subject: Re: howto create partitions bigger than 2TB
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <469CA5B4.5080106@e-dict.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4697760E.4070803@e-dict.net> <46980232.4080500@zytor.com>
	 <469CA5B4.5080106@e-dict.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07, Ingo Freund <linux-kernel-news@e-dict.net> wrote:
> On 14.07.2007 00:52, H. Peter Anvin wrote (please find the answer below the original text):
> > Ingo Freund wrote:
> >> Hi
> >>
> >> I've got a RAID5 (driver aacraid for an ICP9047MA) with four
> >> 750GB hdds which provides a 2.25TB sized device.
> >> None of the until now used tools will work with that device.
> >> fdisk complains about missing cylinder count.
> >> cfdisk misses the device size.
> >> parted shows the right device size but only creates a partion
> >> with 51GB.
> >> What am I supposed to do to work with this device?
> >> Which fs can handle it?
> >> (CONFIG LARGE BLOCK is on)
> >> We are talking about a 32Bit machine with vanilla kernel 2.6.21.5.
> >>
> >
> > You have to use GPT partitions instead of DOS partitions (although you
> > may have to leave your /boot as an DOS partitions, this is supposed to
> > be possible as the two partitioning schemes are designed to coexist, but
> > I don't think parted has support for it yet.)
> >
>
> This is the solution (for use as a data container on a backup machine):
>
> parted /dev/sdb:
> (parted) mklabel gpt
> (parted) mkpart p 0 100%
> (parted) quit
> mkreiserfs /dev/sdb1
> ...and all seems to work.
>

Why not simply
mkreiserfs /dev/sdb
and forget about partitions entirely?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
