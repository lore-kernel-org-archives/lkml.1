Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJBXUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJBXUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYJBXUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:20:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:20417 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYJBXUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iX/nzyBdCpRsg7oF0fwKliKcuFEeA7U5TL0WscqMAi3puRPMT0jJ79fa4veIxm/+dh
         1sk8g4UDtMxr1HkZDbCnXrwlMQmYtNvEQh8B4Y1L1MFp8HHQjHCk+1Xqxgan25mRm6rf
         yOjgwQ9+XLDiaW31AochXrSq28Cwfzef5kVtA=
Message-ID: <86802c440810021620o694c4fe6m1986cffeb1b532d7@mail.gmail.com>
Date: Thu, 2 Oct 2008 16:20:08 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081003010000.731eb2b3@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	 <20081003000314.771b2f68@werewolf.home>
	 <86802c440810021533v572975e8n40e55009cc2b2d8a@mail.gmail.com>
	 <86802c440810021552q1959d4bh348d557430f263d2@mail.gmail.com>
	 <20081003010000.731eb2b3@werewolf.home>
X-Google-Sender-Auth: 8c68cec0ff45d6f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 4:00 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> On Thu, 2 Oct 2008 15:52:11 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:
>
>> On Thu, Oct 2, 2008 at 3:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Thu, Oct 2, 2008 at 3:03 PM, J.A. Magallón <jamagallon@ono.com> wrote:
>> >> On Mon, 29 Sep 2008 18:54:12 -0700, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >>
>> >>>
>> >>> so start from 64k instead of 1M
>> >>>
>> >>
>> >> Or there is something I don't catch about mtrrs, or it still does silly
>> >> things.
>> >>
>> >> I have an ASUS PCDL, dual xeon, 2Gb of memory. Mtrrs after cleanup are:
>> >>
>> >> werewolf:/proc> cat mtrr
>> >> reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
>> >> reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
>> >> reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
>> >> reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
>> >> reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
>> >> reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
>> >> reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
>> >>
>> >> So it adds a last WB zone, but substracts the last 1Mb. (Why do
>> >> I have that stupid uncacheable mb ? probably a bios issue...)
>> >> But those two 64 mb zones could be add to a 128Mb, that new one
>> >> with previous to 256Mb and so on, giving something like:
>> >>
>> >> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>> >> reg01: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
>> >>
>> >> Is this incorrect ?
>> >>
>> >
>> > can you boot with mtrr_cleanup_debug?
>> >
>> > also what is /proc/mtrr with disable_mtrr_cleanup?
>>
>> are you on latest tip/master?
>>
>
> No, I use rc8-git3 with your patches (the small gran_size series and the
> parameter rename, except the debug one) manually applied.
>

ah..
please pick up all of them from tip/master...

      x86: don't need to go to chunksize to 4G
      x86: mtrr_cleanup optimization, v2
      x86: add mtrr_cleanup_debug command line
      x86: cleanup, remove extra ifdef
      x86: mtrr_cleanup hole size should be less than half of chunk_size, v2
      x86: mtrr_cleanup safe to get more spare regs now
      x86: mtrr_cleanup prepare to make gran_size to less 1M
      x86: mtrr_cleanup try gran_size to less than 1M
      x86: change MTRR_SANITIZER to def_bool y


YH
