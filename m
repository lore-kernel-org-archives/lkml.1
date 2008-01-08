Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYAHXkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYAHXkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYAHXkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:40:00 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:1454 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYAHXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=irX87Ld2+0ntYOXIQorXPi9PgwoF4e1LWgxSuJVFmX3lkT9GeUaKHte2P1vvq2n/jMFoYqKnK5Rhv7kfVAOAa5dbpnLUFHbvXzBIv6JrQ3E3NXW6fwhkoe84Zp80Q9K/kyjSwNI1YcziZvy7TsaH5I9N2jxVQR+09DqhxPwRPMI=
Message-ID: <7b9198260801081539x7aee72fbm53b5f298c5faf56@mail.gmail.com>
Date: Tue, 8 Jan 2008 23:39:58 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "Brent Casavant" <bcasavan@sgi.com>
Subject: Re: AF_UNIX MSG_PEEK bug?
Cc: "Rick Jones" <rick.jones2@hp.com>, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.BSF.1.00.0801081716010.24286@pkunk.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
	 <4783FBD6.1000004@hp.com>
	 <7b9198260801081453s198af7efycc7c35668c65eaf1@mail.gmail.com>
	 <alpine.BSF.1.00.0801081716010.24286@pkunk.americas.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2008, Brent Casavant <bcasavan@sgi.com> wrote:
> On Tue, 8 Jan 2008, Tom Spink wrote:
>
> > Where in the code is the message length being sent across the socket?
>
> In do_producer(), there are the following lines in the main loop:
>
>         /* Send random lengths of data */
>         messages[i].length = (rand() % MAXLEN) + sizeof(size_t);
>         iov[i].iov_len = messages[i].length;
>
> The entire "struct sockmsg" is sent across the socket, so the first
> size_t in each message contains the length of the entire message
> (including the size_t).  This size gets picked up at the
> recv(...,MSG_PEEK) line in do_consumer().
>
> Thanks,
> Brent
>
> --
> Brent Casavant                          All music is folk music.  I ain't
> bcasavan@sgi.com                        never heard a horse sing a song.
> Silicon Graphics, Inc.                    -- Louis Armstrong
>

Hi,

But you're not consuming the size_t on the other end.  You're only
peeking it, i.e. you're doing the recv to peek at the message, but
never calling recv to remove that data from the queue... or am I
missing something?

-- 
Regards,
Tom Spink
University of Edinburgh
