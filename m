Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbYEEWQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbYEEWQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYEEWPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:15:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:37045 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYEEWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kbm+/XhbcpamNri4X19MGlxtX2yG6pDz19p/8iyhhgIERjb4Y1LuKtNFZK0d2y3wqfFksRyz6dFEudVifskdER0tjA3YsXjgs6EDdnunFQVvh8Uf9E+WSMLFI6ODmr8AhMctdjeIOAoKQ7FEbDSDSjqoQICmr6QCbHba7IsjmW8=
Message-ID: <30c6373b0805051515t5ffe1b95s77a27588d9dd0e21@mail.gmail.com>
Date: Mon, 5 May 2008 15:15:50 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: Ability to limit or disable page caching?
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <20080505180828.27acf471@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	 <20080505212831.22371732@olorin>
	 <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	 <20080505164446.2ec9a543@cuia.bos.redhat.com>
	 <30c6373b0805051400jebd4132ob23ec38bdf1ccb93@mail.gmail.com>
	 <20080505180828.27acf471@cuia.bos.redhat.com>
X-Google-Sender-Auth: c05f3b82c1e7c0ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that this is part of a larger thread:

http://blogs.smugmug.com/don/2008/05/01/mysql-and-the-linux-swap-problem/

...

and my older post on the subject:

http://feedblog.org/2007/09/29/using-o_direct-on-linux-and-innodb-to-fix-swap-insanity/

mlockall DOES help solve this problem but then MySQL is forced to stay
in memory.

If you have too many connections to the server and it mallocs more
memory and the system can't page anything else it will OOM kill your
mysqld process.

It's MUCH better to have MySQL dip 100MB into swap first....

Kevin

On Mon, May 5, 2008 at 3:08 PM, Rik van Riel <riel@redhat.com> wrote:
> On Mon, 5 May 2008 14:00:51 -0700
> "Kevin Burton" <burton@tailrank.com> wrote:
>
>> > I have no such tunable in my code (yet), because I would like the
>> > kernel to do the right thing automatically.  I will post a 2.6.25 based
>> > kernel RPM for Fedora 9 soon with the split LRU patch series applied.
>>
>> With the same patch you linked to above?  No new code..
>
> Same patch, rediffed against 2.6.25.
>
>> > If you feel like testing/breaking it, I would be interested to see if
>> > it does indeed do the right thing for your workload or if it needs more
>> > tuning.
>>
>> Well we'd be deploying it in product :).. what's the ETA into making
>> it into the official kernel?
>
> The code seems to work right. What is left now is convincing Andrew Morton
> and Linus Torvalds to merge it.
>
> Getting good test results with reasonable workloads where the vanilla
> kernel does the wrong thing (eg. your workload) is probably the most
> important factor for Andrew and Linus in deciding whether or not to
> merge the code.
>
> --
> All Rights Reversed
>



-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
