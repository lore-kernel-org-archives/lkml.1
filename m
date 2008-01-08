Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYAHXq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYAHXq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYAHXqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:46:18 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:10491 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYAHXqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:46:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=edxLj2Spp7daOQ6awjzBq4tK55ppGz/Z/BkiXx2qfQXtDMt6FRBorXKT8pwvPT7YlayjlcV2BCEwPaBNzXoBTiPprkcY60xZzWZ1ee9SeWIw4PH/UKdcguX9w6vt9cwEyDKiszdfsfNTA/Qsbr3xKAmsMloTeSeezwSTQpu2fUQ=
Message-ID: <7b9198260801081546u50f11e9ck32ec6f071efa300d@mail.gmail.com>
Date: Tue, 8 Jan 2008 23:46:15 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "Brent Casavant" <bcasavan@sgi.com>
Subject: Re: AF_UNIX MSG_PEEK bug?
Cc: "Rick Jones" <rick.jones2@hp.com>, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <7b9198260801081539x7aee72fbm53b5f298c5faf56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
	 <4783FBD6.1000004@hp.com>
	 <7b9198260801081453s198af7efycc7c35668c65eaf1@mail.gmail.com>
	 <alpine.BSF.1.00.0801081716010.24286@pkunk.americas.sgi.com>
	 <7b9198260801081539x7aee72fbm53b5f298c5faf56@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2008, Tom Spink <tspink@gmail.com> wrote:
> On 08/01/2008, Brent Casavant <bcasavan@sgi.com> wrote:
> > On Tue, 8 Jan 2008, Tom Spink wrote:
> >
> > > Where in the code is the message length being sent across the socket?
> >
> > In do_producer(), there are the following lines in the main loop:
> >
> >         /* Send random lengths of data */
> >         messages[i].length = (rand() % MAXLEN) + sizeof(size_t);
> >         iov[i].iov_len = messages[i].length;
> >
> > The entire "struct sockmsg" is sent across the socket, so the first
> > size_t in each message contains the length of the entire message
> > (including the size_t).  This size gets picked up at the
> > recv(...,MSG_PEEK) line in do_consumer().
> >
> > Thanks,
> > Brent
> >
> > --
> > Brent Casavant                          All music is folk music.  I ain't
> > bcasavan@sgi.com                        never heard a horse sing a song.
> > Silicon Graphics, Inc.                    -- Louis Armstrong
> >
>
> Hi,
>
> But you're not consuming the size_t on the other end.  You're only
> peeking it, i.e. you're doing the recv to peek at the message, but
> never calling recv to remove that data from the queue... or am I
> missing something?
>
> --
> Regards,
> Tom Spink
> University of Edinburgh
>

Ach.  I *am* missing something... and what I'm missing is my
understanding of the sendmsg and recvmsg calls.

A quick Google has sorted me out.

-- 
Regards,
Tom Spink
University of Edinburgh
