Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYEEUka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYEEUka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYEEUkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:40:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:38132 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYEEUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DglrX4hhSntUELiFE50y8fcpZwy/wTRH1pm2lwKog8SZ7ge6z0tPPh8fm/1Yem2hY08gDG8L5lrksGO3LPWMaLEAfbmIS7nGg48b+Gbw6sx/Ppwp76Lu1hiM3V9NICqa0NSLgBjHnKJdWjMxAqoZk9Yg30LJoTAVXbxFzikHglM=
Message-ID: <30c6373b0805051340h35034de2i378558ea8a9d6cd2@mail.gmail.com>
Date: Mon, 5 May 2008 13:40:17 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Ability to limit or disable page caching?
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <30c6373b0805051331l11a71eacv5cb9a5221f8f26f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	 <20080505212831.22371732@olorin>
	 <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	 <878wyocy0v.fsf@basil.nowhere.org>
	 <30c6373b0805051328n30d32202g3744a233c7efb2dd@mail.gmail.com>
	 <30c6373b0805051331l11a71eacv5cb9a5221f8f26f9@mail.gmail.com>
X-Google-Sender-Auth: b841a6d4fe72aff9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and here's another point I don't fully grok:

http://www.westnet.com/~gsmith/content/linux-pdflush.htm

"By default, Linux will aggressively swap processes out of physical
memory onto disk in order to keep the disk cache as large as possible.
This means that pages that haven't been used recently will be pushed
into swap long before the system even comes close to running out of
memory, which is an unexpected behavior compared to some operating
systems. The /proc/sys/vm/swappiness parameter controls how aggressive
Linux is in this area. "

...

"A value of 0 will avoid ever swapping out just for caching space.
Using 100 will always favor making the disk cache bigger. Most
distributions set this value to be 60, tuned toward moderately
aggressive swapping to increase disk cache. "

..... but we're running on zero and this machine still has 500MB of
free memory.  Why is it swapping?

Kevin

On Mon, May 5, 2008 at 1:31 PM, Kevin Burton <burton@tailrank.com> wrote:
> Though mlockall isn't going to fix this problem because the OOM killer
> will still kill it if it runs out of memory.
>
> I want to preserve the scenario where we go 10 bytes over memory and
> the kernel just swaps out those 10 bytes.
>
> Kevin
>
> On Mon, May 5, 2008 at 1:28 PM, Kevin Burton <burton@tailrank.com> wrote:
>> We're actually running mlock which is native to MySQL.... of course I
>> didn't think about whether our secondary process is paging not our
>> MySQL process.
>
>
> --
> Founder/CEO Tailrank.com
> Location: San Francisco, CA
> AIM/YIM: sfburtonator
> Skype: burtonator
> Work: http://spinn3r.com and http://tailrank.com
> Blog: http://feedblog.org
> Cell: 415-637-8078
> Fax: 1-415-358-419 PIN: 0092
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
