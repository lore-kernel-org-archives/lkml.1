Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYEGEcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYEGEcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYEGEcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:32:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:20801 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYEGEcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O0qb6xSu1ONP4ghGXcNi1MzRS3oXmYcDnqxrPEJGLB3UEyNbylSjxGEPmJJ8fCz2FsxoWExC+SX4N36gxC8hODwLgZ5QVaE8ob2mmY+3vJhyWO683j18ZY/ea7sU8sr7JvmUes8hJK2kS6O3VQqBA66YocxQGDlgjX7poFBvz/U=
Message-ID: <18b669d80805062132m618e0e1fwf92bbb2ced393cb@mail.gmail.com>
Date: Wed, 7 May 2008 13:32:01 +0900
From: "Shigeo N" <shigeonx@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: XTP for 2.6.25
Cc: "Andi Kleen" <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <18b669d80804240314t7b2f6e4cpc9a9f2690c6d21b4@mail.gmail.com>
	 <873apbijb9.fsf@basil.nowhere.org>
	 <18b669d80804240606n47854939x94278f8d974034c1@mail.gmail.com>
	 <18b669d80804250059m793f3f56xc4fdb8bad949fa3@mail.gmail.com>
	 <Pine.LNX.4.64.0804251115470.2363@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m474WUEB027534

I tested again on Linux 2.6.25 with TCP reordering patch.Of course, TCP performance was improved.
Here is the result.
 case2-2) random delay (with TCP reordering patch)
  In this case, add a fixed amount of delay + 10% random delay by command,  "tc change dev eth0 root netem delay 100ms 10ms 25%".
    fixed delay    UDP/TCP/XTP throghput  ---------------------------------------      10ms         88/85/92 Mbps      30ms         88/67/91 Mbps      50ms         88/58/89 Mbps      70ms         88/43/80 Mbps     100ms         88/26/66 Mbps
 case2) random delay (without TCP reordering patch)
  In this case, add a fixed amount of delay + 10% random delay by command,  "tc change dev eth0 root netem delay 100ms 10ms 25%".
    fixed delay    UDP/TCP/XTP throghput  ---------------------------------------      10ms         88/80/92 Mbps      30ms         88/51/91 Mbps      50ms         88/41/89 Mbps      70ms         88/28/80 Mbps     100ms         88/19/66 Mbps
  case1) fixed delay
    In this case, just adds a fixed amount of delay to all packets going out by  command, "tc qdisc add dev eth0 root netem delay 100ms".
    fixed delay    UDP/TCP/XTP throghput  ---------------------------------------      10ms         88/85/92 Mbps      30ms         88/70/91 Mbps      50ms         88/63/89 Mbps      70ms         88/52/84 Mbps     100ms         88/36/70 Mbps
Thanks,
On Fri, Apr 25, 2008 at 5:23 PM, Ilpo JÃ¤rvinen<ilpo.jarvinen@helsinki.fi> wrote:> On Fri, 25 Apr 2008, Shigeo N wrote:>>> case2) random delay>>>>  In this case, add a fixed amount of delay + 10% random delay by>> command, "tc change dev eth0 root netem delay 100ms 10ms 25%".>>>>  Here is the result.>>>>     fixed delay    UDP/TCP/XTP throghput>>   --------------------------------------->>       10ms         88/80/92 Mbps>>       30ms         88/51/91 Mbps>>       50ms         88/41/89 Mbps>>       70ms         88/28/80 Mbps>>      100ms         88/19/66 Mbps>>>>  TCP's perfomance looks very poor when delay is long and variable.>> Where these results with 2.6.25 as well? ...John Heffner just couple of> days ago fixed reordering related problem in TCP (in case that netem> parametrization causes reordering), the fix is not even in 2.6.24.y, I> think...>> -->  i.>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
