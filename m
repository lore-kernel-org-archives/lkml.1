Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbZGMT67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbZGMT67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZGMT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:58:58 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58061 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZGMT66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vpbUZQn8/n0QQvXOqr1JUg8gwB05AZ82+zeEFahvRsD9NO0KQ/i3WU4KFX+Njja8Cr
         blnHRb94IpRgmmiW9L51n2b7qpN+qyDEjeJEcZ2GPgOy5Q9DLYrGlthEaPnq7dyDP5UP
         TpEeq4qC0Kg36piigmRP2dOC47Xr9q2YpW3n4=
MIME-Version: 1.0
In-Reply-To: <20090713195558.GC5569@beaver.vrungel.ru>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> 
	<20090713113252.GB5569@beaver.vrungel.ru> <3e8340490907130654i3d00aa6dt9118004c2fd94689@mail.gmail.com> 
	<20090713195558.GC5569@beaver.vrungel.ru>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 13 Jul 2009 15:58:36 -0400
Message-ID: <3e8340490907131258g35c422ebm5a3147f9a80fd6eb@mail.gmail.com>
Subject: Re: Counters in df, du
To: Alexey Vlasov <renton@renton.name>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Alexey Vlasov <renton@renton.name>:
> On Mon, Jul 13, 2009 at 09:54:22AM -0400, Bryan Donlan wrote:
>> >> Alexey Vlasov <renton@renton.name> writes:
>> >> >
>> >> > I know that df, du can show different values if some files were deleted,
>> >> > but the processes which opened these files are still acting.
>> >>
>> >> You can check for that by doing ls -l /proc/*/fd | grep deleted
>> >>
>> >> It won't tell you the file size though.
>> >
>> > There comes a big list, like this:
>> >
>> > lowx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
>> >
>> > The most interesting is that the /tmp size constantly grows.
>>
>> lsof -n | grep deleted
>
> # lsof -n /tmp | awk '/deleted/ {if ($7 != 0) print$0}'
>
> mysqld    22905                          mysql    6u   REG
> 0,13    20 663938322 /tmp/ib1oZTSZ (deleted)
> mysqld    22905                          mysql    8u   REG
> 0,13 84773 663938424 /tmp/ibRcarbD (deleted)
>
> # df -h /tmp
> Filesystem            Size  Used Avail Use% Mounted on
> tmpfs                 4.1G  3.4G  630M  85% /tmp
>
> It will soon be up to 100% full and I'll have to remount.

Are those the only two results? That should only be adding up to ~84kb
of space...
