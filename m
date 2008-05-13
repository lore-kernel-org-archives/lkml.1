Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYEMTEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYEMTEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYEMTEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:04:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:27528 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYEMTEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YUJyJP7WfgVeXKac0YLlqFDBj3cEDjtJzA3ryXQpbeQC0Xgw1AqhcK7Z/SimDAGN0CPMpK56CYux3VgjO8OF7QhOMKjGJ7CTMe57I4Lp6vtGkovO9hvYNzctbTSQDUTbLTbNI/cGOfWOs2ShXuIZQHd6V+UhzzZMCj8LoxnN0yA=
Message-ID: <19f34abd0805131204y5a3f32c0ya137c0f6e4bfa386@mail.gmail.com>
Date: Tue, 13 May 2008 21:04:05 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Cc: "=?UTF-8?Q?S.=C3=87a=C4=9Flar_Onur?=" <caglar@pardus.org.tr>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <19f34abd0805131103q136e28ddg359de5822b401e0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <200801220119.42312.caglar@pardus.org.tr>
	 <200801221455.16814.caglar@pardus.org.tr>
	 <20080122152333.GB19590@elte.hu>
	 <200801221755.56470.caglar@pardus.org.tr>
	 <20080122160557.GA31831@elte.hu>
	 <19f34abd0805131103q136e28ddg359de5822b401e0c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4DJ4bEB023641

On Tue, May 13, 2008 at 8:03 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:> Hi,>>>  On Tue, Jan 22, 2008 at 6:05 PM, Ingo Molnar <mingo@elte.hu> wrote:>  >>  >  * S.Ã‡aÄŸlar Onur <caglar@pardus.org.tr> wrote:>  >>  >>  > > > My theory is that for whatever reason we get "repeat" IPIs: multiple>  >  > > reschedule IPIs although the other CPU only initiated one.>  >  >>  >  > Ok, please see http://cekirdek.pardus.org.tr/~caglar/dmesg.3rd :)>  >>  >  hm, the IPI sending and receiving is nicely paired up:>  >>  >  [  625.795008] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:>  >  [  625.795223] IPI (@native_smp_send_reschedule) from task amarokapp:2882 on CPU#1:>  >>  >  amarokapp does wake up threads every 20 microseconds - that could>  >  explain it. It's probably Xorg running on one core, amarokapp on the>  >  other core. That's already 100 reschedules/sec.>>  Was this IPI thing ever resolved/fixed? I'm seeing the exact same>  thing on my newest Fedora 8 kernel (2.6.24.5-85.fc8) now:>>   33.3% (334.0)      <kernel IPI> : Rescheduling interrupts>>  And I know for sure that this did not show up a couple of months back.>>  If the cause of this is known, please let me know about it. If it>  isn't, I will start a bisect run now :-)
Ok -- just a confirmation. I have this on v2.6.26-rc1:
Running only init=/bin/sh (from busybox) and powertop shows:kernel IPI : Rescheduling interrupts
completely idle box (except powertop): 1 wakeups/secone busy-loop[1]: 2 wakeups/sectwo busy-loops: 500 wakeups/sec
So it seems like a real bug to me.

Vegard
[1]: while true; do echo hi; done
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
