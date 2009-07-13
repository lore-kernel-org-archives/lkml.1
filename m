Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZGMNyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZGMNyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZGMNyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:54:44 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:33678 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZGMNyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gtfphM0bCV6xEypkJuQlODyZVZVxdR4CUCw66weCscIdpWfOv/2w5DvCZWBOpgQvi6
         nKiuTakPY7EtZ+q+ZYUxmEbhZ0EeHLs8w99Ci6hjZf2qSNIEKPUZWoSliYLOObz8nIJh
         Plfgbe0YNx9QPCTfUlOqpRQak94G91GkhMh0Y=
MIME-Version: 1.0
In-Reply-To: <20090713113252.GB5569@beaver.vrungel.ru>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> 
	<20090713113252.GB5569@beaver.vrungel.ru>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 13 Jul 2009 09:54:22 -0400
Message-ID: <3e8340490907130654i3d00aa6dt9118004c2fd94689@mail.gmail.com>
Subject: Re: Counters in df, du
To: Alexey Vlasov <renton@renton.name>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Alexey Vlasov <renton@renton.name>:
> On Mon, Jul 13, 2009 at 11:09:29AM +0200, Andi Kleen wrote:
>> Alexey Vlasov <renton@renton.name> writes:
>> >
>> > I know that df, du can show different values if some files were deleted,
>> > but the processes which opened these files are still acting.
>>
>> You can check for that by doing ls -l /proc/*/fd | grep deleted
>>
>> It won't tell you the file size though.
>
> There comes a big list, like this:
>
> lowx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
> lrwx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
> lrwx------ 1 root root 64 Jul 13 14:58 1763 -> /tmp/ZCUDXqiMTp (deleted)
> [cut]
> lrwx------ 1 root root 64 Jul 13 15:29 317 -> /tmp/ZCUDXiOHCk (deleted)
> lrwx------ 1 root root 64 Jul 13 15:29 317 -> /tmp/ZCUDXiOHCk (deleted)
> lrwx------ 1 root root 64 Jul 13 15:29 317 -> /tmp/ZCUDXiOHCk (deleted)
>
> But you can see the file date, these are new files and by next search
> you won't see them any more.
>
> The most interesting is that the /tmp size constantly grows.

Try:

lsof -n | grep deleted

This will show the process holding them more easily, and the file size
(in the seventh column). It won't show the date they were opened
though.
