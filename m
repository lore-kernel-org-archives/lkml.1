Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZHJW0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZHJW0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZHJW0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:26:40 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:57982 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbZHJW0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <5d5443650908100031t5240daa4h76ef2a7863cc4403@mail.gmail.com>
References: <20090808130315.GA12930@elf.ucw.cz>
	 <5d5443650908080942l50d91d31qb23c494affdf6850@mail.gmail.com>
	 <20090808214454.GB24153@elf.ucw.cz>
	 <5d5443650908100031t5240daa4h76ef2a7863cc4403@mail.gmail.com>
Date: Mon, 10 Aug 2009 15:26:36 -0700
Message-ID: <d6200be20908101526m31a422feid09c89ab5675220c@mail.gmail.com>
Subject: Re: HTC Dream for staging: add support for input on GPIO pins
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       kernel list <linux-kernel@vger.kernel.org>, swetland@google.com,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 12:31 AM, Trilok Soni<soni.trilok@gmail.com> wrote:
> Hi Pavel,
>
> On Sun, Aug 9, 2009 at 3:14 AM, Pavel Machek<pavel@ucw.cz> wrote:
>> On Sat 2009-08-08 22:12:46, Trilok Soni wrote:
...
>>> I don't see any importance of gpio_matrix.c when we already have
>>> generic gpio matrix driver mainlined. I would suggest to remove those
>>> bits from this patch. I have added linux-input ML.
>>
>> Well, I'm trying for staging merge at this point. Reasons why
>> gpio_matrix is there are:
>>
>> 1) it is non-trivial to remove
>>
>> 2) it has some features mainline lacks
>>
>> 3) HTC Dream actually works with it
>>
>> (and 4) I'd like to submit code as Arve wrote it, then transform/clean
>> it up in staging).
>>
>> Of course, relevant features will need to be extracted from
>> gpio_matrix and merged at the right places, and that needs to happen
>> before move from staging/, but I'd like to have working keyboard in
>> the meantime.
>
> gpio_matrix in mainline should work with HTC G1 with few proper
> platform data and input name eventhough ghost key clearance code is
> not yet in mainline driver.

It would also be missing the end-call and volume keys.

>
> I know you want HTC dream to work through staging but I would prefer
> that such drivers should be discussed and reviewed on
> linux-input/linux-kernel ML and not just dumped in staging.

As I mentioned when the matrix keypad driver was posted, we moved away
from having separate matrix and gpio input drivers since the the
hardware we use mix both types in the same logical keyboard. I did not
see any discussion about alternative ways to do this.

The current version of our driver (though this code does not appear to
be included this path) also supports creating multiple input devices
from a single set of inputs. This is needed on several new devices
where the trackball button is in keypad matrix and it is needed if you
want to report the same keycode from multiple keys (e.g. dream
external menu key and menu key in main keyboard).

-- 
Arve Hjønnevåg
