Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0CIBwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:52:04 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33672 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab0CIBwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OItiWFYpjV+m9jd9rdTneQ2Bf3u935d1Jrfwc2SPxHp8TEKXcM3Ag/Tc8zmmQ1dFbG
         ELD3GgnpXL+V7L7GBEzxhZjVJPPr0BnjpAqXS/EYoCMRyu6JeEVElTvKtp4Or+F1ZOcH
         DsxODlqMAitlocnz8rYSCNktxc1tLrrGSE6Bs=
MIME-Version: 1.0
In-Reply-To: <20100309012552.GR30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	 <20100308094647.GA14268@elte.hu>
	 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	 <20100308184521.GK30031@ZenIV.linux.org.uk>
	 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
	 <ff13bc9a1003081718k1e7964f5ta9e582866dea94ee@mail.gmail.com>
	 <20100309012552.GR30031@ZenIV.linux.org.uk>
Date: Tue, 9 Mar 2010 02:51:55 +0100
Message-ID: <ff13bc9a1003081751s535fbf71l9d261b303587b23a@mail.gmail.com>
Subject: Re: Upstream first policy
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 4. It doesn't matter at all if anyone reads a file that happens to be
>> at /etc/shadow while not containing shadow passwords (with the same
>> path, but different content)
>
> What the hell are you smoking?

I mean, what is interesting for security of reading is the fact that
the file contains shadow passwords (and thus is labeled as "secret" or
with a specific label), not that it is at /etc/shadow.

The same security check would need to apply to an administrator's
backup copy of /etc/shadow, but would not need to apply in the
hypotetical case that /etc/shadow did not contain shadow passwords,
but, say, was empty or contained a pointer to a network server to use.

This is to illustrate the point, not something expected to happen; it
also represents the ideal security model, not necessarily any concrete
one.

So what really is interesting for reads is what the content is (in
practice, what the content label is), not the path.

For writes, it is exactly the opposite: you don't care about writing
to a private copy, but you don't want to let a random file be put on a
system path.
For instance, if I copy /etc/passwd somewhere else, the result should
have the same content label (since it is identical), but I should now
be able to write to it since the path allows me to.
