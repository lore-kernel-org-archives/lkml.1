Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZBQU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZBQU6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZBQU6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:58:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:40005 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZBQU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:58:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jkDOMBJhjnH0K0Tp4efUxpE33aazEKRTJhZuUiYKH5q8DBYjo7FvVbx+EZ1ELRdAM6
         DKT9xXqlQUEwNzz1/YQD+0sGf2BUGLsSn7n6TEO7PaquLKrQ/NmrDG1eFcJugmu8MNYZ
         dkVlmuey7P+kby13xlnhOWkDPuDCHo3BY6Sus=
MIME-Version: 1.0
In-Reply-To: <20090217102407.GB6298@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
	 <20090213145124.GB13000@alberich.amd.com> <4995B35F.5080708@zytor.com>
	 <20090217102407.GB6298@alberich.amd.com>
Date: Tue, 17 Feb 2009 12:58:21 -0800
X-Google-Sender-Auth: 39d2fa2841e7676c
Message-ID: <86802c440902171258t6f542624ge679c861c4bb3023@mail.gmail.com>
Subject: Re: [PATCH 2/7] x86: memtest: introduce array to store memtest 
	patterns
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 2:24 AM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Fri, Feb 13, 2009 at 09:52:31AM -0800, H. Peter Anvin wrote:
>> Andreas Herrmann wrote:
>> > -#define _MAX_MEM_PATTERNS 4
>> > +static unsigned long patterns[] = {
>> > +   0UL,
>> > +   -1UL,
>> > +#ifdef CONFIG_X86_64
>> > +   0x5555555555555555UL,
>> > +   0xaaaaaaaaaaaaaaaaUL,
>> > +#else
>> > +   0x55555555UL,
>> > +   0xaaaaaaaaUL,
>> > +#endif
>> > +};
>>
>> Why not just use u64 for the pattern even on 32 bits?
>
> I just assumed that this was a settled thing.
>
> Yinghai, was there a specific reason why you did not use an u64 for
> the memory test pattern on 32-bit?
> (See commit 1f067167a83d1c7f80437fd1d32b55508aaca009 "x86: seperate
> memtest from init_64.c")
>
> If not I'll adapt this and send out a new patch set.

should be ok,  but please make sure target range is u64 alignment.

YH
