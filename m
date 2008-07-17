Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbYGQPrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbYGQPrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbYGQPrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:47:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:62508 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYGQPrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WwSy5s21XCE+dV8hh2Lku/V7RSgDsFLIETjdTj7ce/pRYFioDuAzz2xSUUBC83dOdD
         TY9DTXeiFgCvTrs9hyO0cNnpffHblkKE/56WFwaklACjvEK+izlEoSbiUzYJIuotqeD7
         1eAhGV+gMd/mjMTF/Jsz9rHuOwYAL7P/ipcK8=
Message-ID: <d58509a80807170847p6ef05a8av96b6c8828a33821@mail.gmail.com>
Date: Thu, 17 Jul 2008 16:47:13 +0100
From: "Robert Lougher" <rob.lougher@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Squashfs-devel] Squashfs mainlining status?
Cc: "Peter Korsgaard" <jacmet@sunsite.dk>,
       "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       squashfs-devel@lists.sourceforge.net,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807171729450.29859@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.64.0806021650190.28709@vixen.sonytel.be>
	 <48460906.2080205@lougher.demon.co.uk>
	 <87od6h7d7l.fsf@macbook.be.48ers.dk>
	 <Pine.LNX.4.64.0807171729450.29859@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 4:35 PM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:
>        Hi Peter,
>
> On Wed, 4 Jun 2008, Peter Korsgaard wrote:
>> >>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:
>>  Phillip> The major work of course is the move to a little endian
>>  Phillip> layout without any bit fields in the structures to make it
>>  Phillip> easier to swap member fields on big-endian architectures.
>>  Phillip> I'm currently working on this on a non-CVS branch.
>>  Phillip> Most of the work till now has been without any attempt to
>>  Phillip> retain backwards compatibility with the current 3.3
>>  Phillip> little-endian filesystem layout.  After your private email
>>  Phillip> regarding retaining backwards compatibility I will look
>>  Phillip> again at this issue, it may well be that I will abandon my
>>  Phillip> current layout changes that I have so far made.
>>
>> What private mail? Anything of interest to the rest of the group? As I
>
> Oops, I've just returned from holidays, and realize I never actually responded
> to this question. So here is the gist of it:
>
> | I had a closer look at the structures and bitfields, and I still think it's
> | possible to stay compatible with the current little endian layout:
> |   1. About half of the bitfields are actually bytes or 16-bit words. Hence
> |      these can easily be converted to __u8 or __le16.
> |   2. Most of the remaining bitfields sit in an 8, 16, or 32 bit integer.
> |      Hence these can be converted to such an integer (or an array of bytes,
> |      cfr. 3 below), and accessed using get_unaligned_le{16,32}() and a
> |      shift/mask operation.
> |   3. There are a few bitfields that sit in an `odd' number of bytes. These
> |      can be converted to an array of bytes, and accessed using
> |      get_unaligned_le{16,32}() and a shift/mask operation.
> |   4. The integral fields in the structs should be accessed using
> |      get_unaligned_le{8,16,32}(), too.
>
> I noticed the squashfs CVS repository is getting a new (incompatible) 4.0
> layout now?
>
> What do people think?
>

Last time I looked you were not the maintainer of squashfs.  Phillip
spent a long time examining the possibility of maintaining
compatibility but decided asthat there were sufficient advantages in a
new layout to warrant the change.

Rob.

> With kind regards,
>
> Geert Uytterhoeven
> Software Architect
>
> Sony Techsoft Centre Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
>
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@eu.sony.com
> Internet: http://www.sony-europe.com/
>
> A division of Sony Europe (Belgium) N.V.
> VAT BE 0413.825.160 · RPR Brussels
> Fortis 293-0376800-10 GEBA-BE-BB
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Squashfs-devel mailing list
> Squashfs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/squashfs-devel
>
>
