Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZCJQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZCJQG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZCJQFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:05:25 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59991 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbZCJQFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bcX34RKtFnKQ3hxlrYqeMtRHkXhci2VyTMlH7q1DUqjwQJDQM7oIvDpp1QBuh5yPiv
         56qMqwcHtNo7d65Vl9cniP0pO9xNfGKKS0mjWDDwxijOopNnawB4Ebk7RPkETaVy8dRe
         /Z1hDDBLUKU77KVIsLBB/J0IuUt3DekL0a9qA=
MIME-Version: 1.0
In-Reply-To: <49B68C37.8010803@freescale.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <49B68C37.8010803@freescale.com>
Date: Tue, 10 Mar 2009 16:05:20 +0000
Message-ID: <87a5b0800903100905l71f15141n7a273df21bfa77e2@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Will Newton <will.newton@gmail.com>
To: Timur Tabi <timur@freescale.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       hancockrwd@gmail.com, jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 3:50 PM, Timur Tabi <timur@freescale.com> wrote:
> Alan Cox wrote:
>
>> NAK this - on a lot of platforms 1uS is the wrong timescale. Also we
>> shouldn't be encouraging this kind of polling by making it very easy to
>> write.
>
> Well, I can agree that the time scale might be wrong on some platforms.
>  The original version of spin_event_timeout() used jiffies, but some
> people said that a jiffy is too long of a timescale, so I changed it to
> udelay.

The correct timescale is rather application dependant - for some
accesses that cross clock domains it can be a requirement to wait for
a small number of core clock cycles (2 - 20) for a condition to become
true, for others, e.g. PIO, it is more appropriate to wait for a few
100 cycles.
