Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZEaGOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZEaGOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZEaGOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:14:04 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:45103 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZEaGOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j4TIM229OBNaQHuzslpQnXSXIfCd3cSVDHGx6M/k9KYuHYzz6QLZXSy89pAyRbFDze
         FySaIu0z9ILWdW0yOd810SFVnctQRavq9cdFWBiMDs0TQcnqgrVZjTWaqTZBDxBlZPPt
         RQ+yAw0zHmG5jRgYqqmDwc+vhr/mZqH2nd4Mo=
MIME-Version: 1.0
In-Reply-To: <20090531001052.40ac57d2@lxorguk.ukuu.org.uk>
References: <20090528090836.GB6715@elte.hu>
	 <20090530082048.GM29711@oblivion.subreption.com>
	 <20090530173428.GA20013@elte.hu>
	 <20090530180333.GH6535@oblivion.subreption.com>
	 <20090530182113.GA25237@elte.hu>
	 <20090530184534.GJ6535@oblivion.subreption.com>
	 <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com>
	 <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
	 <20090531001052.40ac57d2@lxorguk.ukuu.org.uk>
Date: Sun, 31 May 2009 09:14:03 +0300
X-Google-Sender-Auth: 5f96ceaa27866dc7
Message-ID: <84144f020905302314w12c4c7f8jc8241e36c847f53e@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Sun, May 31, 2009 at 2:10 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> It's pretty damn obvious that Larry's patches have a much bigger
>> performance impact than using kzfree() for selected parts of the
>> kernel. So yes, I do expect him to benchmark and demonstrate that
>> kzfree() has _performance problems_ before we can look into merging
>> his patches.
>
> We seem to be muddling up multiple things here which is not helpful.

Yup.

On Sun, May 31, 2009 at 2:10 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> There are three things going on
>
> #1 Is ksize() buggy ?

No, there's nothing wrong with ksize() I am aware of. Yes, Larry has
been saying it is but hasn't provided any evidence so far.

On Sun, May 31, 2009 at 2:10 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> #2 Using kzfree() to clear specific bits of memory (and I question the
> kzfree implementation as it seems ksize can return numbers much much
> bigger than the allocated space you need to clear - correct but oversize)
> or using other flags. I'd favour kzfree personally (and fixing it to work
> properly)

Well, yes, that's what kzfree() needs to do given the current API. I
am not sure why you think it's a problem, though. Adding a size
argument to the function will make it more error prone.

On Sun, May 31, 2009 at 2:10 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> #3 People wanting to be able to select for more security *irrespective*
> of performance cost. Which is no different to SELinux for example.

Yeah, as I said before, I really don't have any objections to this. I
just think nobody is going to enable it so memset() or kzfree() in
relevant places is probably a good idea.

                                   Pekka
