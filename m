Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZFARbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZFARbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbZFARb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:31:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61960 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZFARb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OGT0+daJaWELDc/nhSVVx17AIYkmLH9UPxsy8aqUz4OXpcB6/J41uyNjBzhBu9Ay3B
         UbOsv+odisA+FFi9R2q20bV+xxb/HwMlTCqfvrOdU1+dsxumn5JiCVNoDvvNk3yc2Cpw
         oMUsEBRpFJcBxrayjQ7Zy9qLcn+ZmCIFOj8w0=
MIME-Version: 1.0
In-Reply-To: <4A2409C3.2000804@zytor.com>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
	 <20090528164720.0af5752b.akpm@linux-foundation.org>
	 <20090529103329.GB23530@aftab>
	 <20090529130115.a44efaee.akpm@linux-foundation.org>
	 <20090530081954.GA21954@liondog.tnic>
	 <20090530014007.3c1e22d5.akpm@linux-foundation.org>
	 <4A218761.5080607@zytor.com> <20090601145326.GA28260@liondog.tnic>
	 <4A2407D1.5050706@zytor.com> <4A2409C3.2000804@zytor.com>
Date: Mon, 1 Jun 2009 10:31:29 -0700
Message-ID: <6dc9ffc80906011031t3aa4a91br84e4d06df76b0065@mail.gmail.com>
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 1, 2009 at 10:02 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> H. Peter Anvin wrote:
>>
>> Yes, we would have to do something like that.
>>
>> However, if you're doing that you shouldn't use typeof() there...
>> instead this should be turned into an inline function with explicit
>> 64-bit types.
>>
>> It would be good if we could get Kbuild to export some kind of macro
>> that we can use to test binutils version, so we can do something like:
>>
>> #if BINUTILS_VERSION >= KERNEL_VERSION(2,18,50)
>> /* Do the right thing */
>> #else
>> /* Do the wrong thing */
>> #endif
>>
>
> The other option, and perhaps a better option, is to key it on the
> version of gcc; then we can use the gcc intrinsics __builtin_popcount(),
> __builtin_popcountl() and __builtin_popcountll(), which should produce
> better code since gcc can schedule them appropriately.
>
> Probably also means passing -msse4.2 to gcc while hoping that that
> doesn't enable any #TS-generating instructions (SSE 4.2 is mostly a
> collection of integer instructions).
>
> (H.J., any comments?)
>

I don't think -msse4.2 will generate any SSE instructions unless you
turn on the vectorizer.


-- 
H.J.
