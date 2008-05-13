Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYEMSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYEMSDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYEMSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:03:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:46477 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbYEMSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MMCbBKkQSH4hTl/mNbueCpAe3HriPL96kqXFRTkINlDEBBD/marRCKGn3u+d0y3eX0VmEoew4W/kKvn3xilmoCTqpT2DdId2A5xE7kaTB/gSW09TxUV6EciVKSDSQWqatooPBOyIV5msRNOUzLrmHCMhCiAEpAAtVp6sDuOmK6s=
Message-ID: <19f34abd0805131103q136e28ddg359de5822b401e0c@mail.gmail.com>
Date: Tue, 13 May 2008 20:03:06 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Cc: "=?UTF-8?Q?S.=C3=87a=C4=9Flar_Onur?=" <caglar@pardus.org.tr>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <20080122160557.GA31831@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <200801220119.42312.caglar@pardus.org.tr>
	 <200801221455.16814.caglar@pardus.org.tr>
	 <20080122152333.GB19590@elte.hu>
	 <200801221755.56470.caglar@pardus.org.tr>
	 <20080122160557.GA31831@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4DI3LEB022015

Hi,
On Tue, Jan 22, 2008 at 6:05 PM, Ingo Molnar <mingo@elte.hu> wrote:>>  * S.Ã‡aÄŸlar Onur <caglar@pardus.org.tr> wrote:>>> > > My theory is that for whatever reason we get "repeat" IPIs: multiple>  > > reschedule IPIs although the other CPU only initiated one.>  >>  > Ok, please see http://cekirdek.pardus.org.tr/~caglar/dmesg.3rd :)>>  hm, the IPI sending and receiving is nicely paired up:>>  [  625.795008] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:>  [  625.795223] IPI (@native_smp_send_reschedule) from task amarokapp:2882 on CPU#1:>>  amarokapp does wake up threads every 20 microseconds - that could>  explain it. It's probably Xorg running on one core, amarokapp on the>  other core. That's already 100 reschedules/sec.
Was this IPI thing ever resolved/fixed? I'm seeing the exact samething on my newest Fedora 8 kernel (2.6.24.5-85.fc8) now:
  33.3% (334.0)      <kernel IPI> : Rescheduling interrupts
And I know for sure that this did not show up a couple of months back.
If the cause of this is known, please let me know about it. If itisn't, I will start a bisect run now :-)
Thanks.

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
