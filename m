Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZHaXy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZHaXy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZHaXy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:54:28 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:64359 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZHaXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=b2M62x5Z9NbxdKSZIx8/fQOeT2vTE11pzpJvRqPORRdnPDd2inbua9J//VB4ezXrQL
         VhFcA/E8r/67hviJYOE1baNjiz2QbsiGmEsa1gUorFB/GJjrwLkCGKB+qce7IBOKyAuT
         wto2xB4qraxR722yiKl6iTCFsZVAGUFG7xmhc=
MIME-Version: 1.0
In-Reply-To: <43e72e890908311302s58743978wd8950f167a871cfb@mail.gmail.com>
References: <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <43e72e890908281509o44930348w581b865107ea3e98@mail.gmail.com> 
	<43e72e890908310123w5d361ed5tff58a7663044bdcd@mail.gmail.com> 
	<43e72e890908311050s320d0ceen312a0d3d9e4fbc76@mail.gmail.com> 
	<43e72e890908311137k78ac439bs4edf376d07343a32@mail.gmail.com> 
	<43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com> 
	<20090831193345.GG5631@tuxdriver.com> <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com> 
	<20090831194753.GH5631@tuxdriver.com> <43e72e890908311302s58743978wd8950f167a871cfb@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Aug 2009 16:54:09 -0700
Message-ID: <43e72e890908311654t5d9489d3w9a817cffab5cb8f8@mail.gmail.com>
Subject: Re: memleaks, acpi + ext4 + tty
To: "John W. Linville" <linville@tuxdriver.com>,
       Eric Paris <eparis@parisplace.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 1:02 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Mon, Aug 31, 2009 at 12:47 PM, John W.
> Linville<linville@tuxdriver.com> wrote:
>> On Mon, Aug 31, 2009 at 12:43:01PM -0700, Luis R. Rodriguez wrote:
>>> On Mon, Aug 31, 2009 at 12:33 PM, John W.
>>> Linville<linville@tuxdriver.com> wrote:
>>
>>> > My guess is that the culprit is between
>>> > v2.6.31-rc8 and whatever is at the head of linux-2.6-allstable.
>>>
>>> But the issue is *not* in linux-2.6-allstable, it is only present on
>>> wireless-testing, and I went as far back as merge-2009-08-28. I was
>>> using whatever tag was available prior to you moving to rc8, and that
>>> worked.
>>
>> OK, then I can only guess that something went wrong in your bisection
>> (e.g. dirty build, something not marked properly, etc).
>
> Well so remember I did a clean git clone of wireless-testing and the
> issue was still there, but I determined just now it seems rc8 from
> Linus does indeed also have the issue. For some reason the issue was
> not present on hpa's rc8 on linux-2.6-allstable. Will double check on
> that again.

OK so hpa's tree just had all of Linus' stuff pulled, not just rc8. It
turns out Eric Paris' inotify patches are required to fix 2.6.31-rc8
for me.. I tested just one patch and it fixed my bootup lag:

http://git.infradead.org/users/eparis/notify.git/commit/b962e7312ae87006aed6f68ceee94bdf8db08338

FWIW for that patch:

Tested-by: Luis R. Rodriguez <lrodriguez@atheros.com>

So -- you if you're like me and had issues with bootup lag on
wireless-testing, you can probably fix your wireless-testing by
pulling his patches:

git pull git://git.infradead.org/users/eparis/notify.git for-linus

I saw Linus had some other fixes but I'll wait for rc9 for that as my
box seems reasonably stable right now.

  Luis
