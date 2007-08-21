Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbXHURqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbXHURqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758393AbXHURqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:46:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:59539 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbXHURqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bx2BYpyGCEFJ6O7SgtMRAZfU42ssUXeBpMZRtCfbPJ3PRa8gIY/iEf9pSg382s0ds69CjaY85blmkGh647XvSbrwgI9l+APvU49I+4vARNy3N2TZZlQ1Tzca/msBmGq1HYkcfRjKKIaS8I6tI0R0MweNWhLqmilPGnl6i/zS5W4=
Message-ID: <5d6222a80708211046xe248cdcw5193a0dc8f4ff0a8@mail.gmail.com>
Date: Tue, 21 Aug 2007 14:46:02 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Laurent Vivier" <Laurent.Vivier@bull.net>
Subject: =?ISO-8859-1?Q?Re:_R=E9f._:_Re:_[PATCH_0/4]_Vi?= =?ISO-8859-1?Q?rtual_Machine_Time_Accounting?=
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "John Stoffel" <john@stoffel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <46CA9831.4080309@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF945F7B1F.FF4B4672-ONC125733D.006266E7-C125733D.00626843@frec.bull.fr>
	 <5d6222a80708201334q27fc6cbcr7ce6a9d7147437a2@mail.gmail.com>
	 <46CA9831.4080309@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> Glauber de Oliveira Costa wrote:
> >> by doing this at kernel level, we can:
> >> - measure exactly the guest time,
> >> - move this part of system time to user time (as you think it should be
> >> user time),
> >> - have consistency between system, user and guest time,
> >> - report values in /proc/state and /proc/<pid>/state, at system wide level
> >>
> >> I'm not sure we can measure the guest time at the qemu user level.
> >>
> >> Perhaps Rusty can say what he thinks about this ?
> >>
> > Even if we cannot _now_, isn't that an easier, and safer change? (and
> > I don't think we lose anything by design).
>
> Could you explain ? How should I do this ?
> I'm _sure_ it is not easier to do that at qemu level.
>
> I don't like to patch kernel (it is the last thing I do to solve a problem: I
> know there is always at least one guy to not agree the patch :-P ) but in this
> case I think this is the best way to do that.
>
> I think the virtualization notion should be introduced at the kernel level, at
> least in the kernel statistics: it is generic, it can be used by other
> virtualization tools. As I said, until know CPUs have got only two states
> reflected in statistics by "user time" and "system time". Since recently, they
> have introduced a third state, the virtual CPU, that, in my opinion, should be
> also reflected in the CPU statistics as the "guest time".

After a second thought on this, you seem to be right.

> >
> > Although I don't know KVM to a that deep level, I think it should be
> > possible to keep the virtual cpus in different process (or threads),
> > and take the accounting time from there. Perfectly possible to know
> > the time we spent running (user time), and the time the hypervisor
> > spent doing things on our behalf (system time).
>
> But we have always user time accounted as system time. CPU stats are wrong if we
> do not modify the kernel. Can you live with wrong statistics ? (yes, I think,
> you can, but perhaps someone else not)
>
No, I can't. Just because I suggested an alternate way (even if it was
wrong), it does not mean I want things to be done wrongly.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
