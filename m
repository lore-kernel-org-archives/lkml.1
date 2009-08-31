Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZHaT7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZHaT7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZHaT7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:59:06 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:37932 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZHaT7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NkCquyaIqUgs8pJVgY21nlnFcp4Gd+hGaRLTvdWMssQ1BhTw83ElPubbvOCxCsXpvl
         UKXL+P2Kp3S3banOf1DU+CDXcB1/FDA/CidCwlB9skKB8lH/HEbQVDlgi8oHnwUILUwV
         kTzbIc1WD3Onp+fOMNrpXWM0Lz/rMX/Q9h1MQ=
MIME-Version: 1.0
In-Reply-To: <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> 
	<43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com> 
	<43e72e890908281450k78cc1a2fmd4fd033ae0f4176f@mail.gmail.com> 
	<43e72e890908281509o44930348w581b865107ea3e98@mail.gmail.com> 
	<43e72e890908310123w5d361ed5tff58a7663044bdcd@mail.gmail.com> 
	<43e72e890908311050s320d0ceen312a0d3d9e4fbc76@mail.gmail.com> 
	<43e72e890908311137k78ac439bs4edf376d07343a32@mail.gmail.com> 
	<43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com> 
	<20090831193345.GG5631@tuxdriver.com> <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Aug 2009 12:58:46 -0700
Message-ID: <43e72e890908311258y45565a9fo1e739992c00b650@mail.gmail.com>
Subject: Re: memleaks, acpi + ext4 + tty
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 12:43 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Mon, Aug 31, 2009 at 12:33 PM, John W.
> Linville<linville@tuxdriver.com> wrote:
>> On Mon, Aug 31, 2009 at 12:30:15PM -0700, Luis R. Rodriguez wrote:
>>> On Mon, Aug 31, 2009 at 11:37 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>>
>>> > OK I tried this, I even 'rm -rf * ; git checkout -f' and ..
>>> > merge-2009-08-28 tag yields the same issues, long lag upon bootup with
>>> > some kmemleaks I cannot even get to check. So somehow something is
>>> > different between merge-2009-08-28 and Linus' rc8. This is just
>>> > bizarre so to be even safer I'm just going to do a fresh git clone on
>>> > wireless-testing.
>>>
>>> Hey John so I tested wireless-testing on the merge-2009-08-28 tag on a
>>> fresh git pull and verified this is indeed busted for me. Although I
>>> had tried hpa's linux-2.6-allstable on HEAD just to be sure I am now
>>> building Linus' tree from a fresh git clone on the v2.6.31-rc8 tag
>>> just to be double check this was indeed not a 2.6.31-rc8 issue but
>>> instead *something* on wireless-testing. What that something is is
>>> unclear to me still, I guess after all these tests I'll run a manual
>>> diff as git doesn't seem to be picking anything up.
>>
>> As you determined, there is no difference between merge-2009-08-28
>> and v2.6.31-rc8.  If one works and the other doesn't, then the main
>> thing not working will be git...
>
> Hm that would suck big time. At any rate, even if it was git
> wireless-testing seems to have an issue right now. I'll confirm
> shortly with Linus' own tree.
>
>> What is linux-2.6-allstable?
>
> hpa's collection of 2.6 stable kernels, including extraversion stuff.
>
>> My guess is that the culprit is between
>> v2.6.31-rc8 and whatever is at the head of linux-2.6-allstable.
>
> But the issue is *not* in linux-2.6-allstable, it is only present on
> wireless-testing, and I went as far back as merge-2009-08-28. I was
> using whatever tag was available prior to you moving to rc8, and that
> worked.

Good news is Linus' rc8 tag *has the same issue* so the reason why
wireless-testing has it is rc8 *does indeed have it*.

So Peter, if there is something extra or missing from
linux-2.6-allstable head it certainly fixed my issues, will have to
try a new respin of it to ensure it wasn't a fluke. Odd thing too
though is even my distribution kernel (karmic rc8 generic) works fine.

At least now I can safely bisect between rc7 and rc8, or pull the
kmemleaks branch and see if that fixed.

  Luis
