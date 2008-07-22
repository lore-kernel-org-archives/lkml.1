Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYGVEry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYGVEry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYGVErq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:47:46 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:38349 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYGVErp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wiKX0Jj93F1ZJbbgo9wQeH5mc744ytZhSruOrX0Im2vYPMqCEgLKwvKqCjHwOu2/m1
         kj0xdtyd5RfCUUI+aSmBB2i7j77YMxivZSiRD+3cpw7QhcDwdfrlENpxGzU1yJT+jXks
         UiiquvKD+UIzsRQyOl0BQz1mJxNzX11vcBfN4=
Message-ID: <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com>
Date: Mon, 21 Jul 2008 21:47:44 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot boot
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       "Ivan Seskar" <Seskar@winlab.rutgers.edu>,
       jfm3 <jfm3@winlab.rutgers.edu>, Sujith <m.sujith@gmail.com>
In-Reply-To: <48851AC2.8030007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
	 <48848DDF.6010903@zytor.com>
	 <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>
	 <48851AC2.8030007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 4:24 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Mon, Jul 21, 2008 at 6:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> Luis R. Rodriguez wrote:
>>>>
>>>> This bug seems to be present since 2.6.22 [1], so hope we can get this
>>>> fixed ASAP. Let me know if you have patch suggestions I can test.
>>>>
>>>> This crashes very early, I had to use earlyprintk to get it.
>>>>
>>
>> I've put extra spaces between the culprit.
>>
>> c0387ac2:       0f 1f 40 00             nopl   0x0(%eax)
>>
>
> Sure enough, our old friend.
>
> You have in your configuration:
>
> CONFIG_M686=y
> # CONFIG_X86_GENERIC is not set
>
> ... so this is fully expected; CONFIG_M686 without CONFIG_X86_GENERIC is not
> compatible with such processors.
>
> Not a bug.

Thanks for taking a  look at this. So well, it would be a
misconfiguration bug by the distribution then to try to support a
generic 686 kernel wihtout GENERIC then.

  Luis
