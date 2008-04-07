Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYDGIOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYDGIOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYDGIO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:14:29 -0400
Received: from web26201.mail.ukl.yahoo.com ([217.12.10.238]:34287 "HELO
	web26201.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754329AbYDGIO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:14:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2XHGv/yaWVujGnHk2f7O69og5zWXCuQ1abbQqpDpyFLRN29n15NHpUK4yVbRP/jai7d+Y0f7KxW8PhfKevyz75Db3KyuhzfWw6zM6AJVNXil+/hEc+B8r6m84D8FoeERNwaatqJO1kZ1XvtLnQYbJguidkX3VefSM6PtchXycxs=;
X-YMail-OSG: ZgjxsvAVM1mTUkOiZfPat8x9j9rSeGJ5jlDY59loArOj__J7KC16tCzIIjP2jeIi93EE1v2nD4C9afAAfBUuG2IBbAIgdWCNji.XgQBkPqczRDEFeSLQya5G7n8-
X-Mailer: YahooMailWebService/0.7.185
Date: Mon, 7 Apr 2008 08:14:24 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Reply-To: trimarchimichael@yahoo.it
Subject: Re: [PATCH] atmel serial reduce trasmitting window & code style patch
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080406165700.7802ef6f@siona.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <953572.15413.qm@web26201.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Ok, the patch seems to make sense, but your description
> isn't very good...
ok
>   * What problem does this patch solve (I think I know it,
> but I don't
>     want to guess.)
I try to resolve this problem:
The serial is set in interrupt mode 9600, and trasmit a lot of data.
The serial receive data from another device. The receive buffer is
1024 bytes and the trasmit buffer is an XMIT_SIZE. So when the tasklet
start to trasmit, it can loose data.
>   * This patch doesn't really reduce any "TX
> window" since the window
>     simply didn't exist before (or was infinitely long
> or whatever.) I
>     think you should mention that this limitation is a new
> thing.

>   * Why is 32 a good value?
> 
... I don't know a good value, because the tasklet can be preempted,
and the receiving buffer can be fill in background. It is hard to choose
a good value...
> Also, do we need to reschedule the tasklet if we terminate
> the loop
> because of this limit? I think we can get away with not
> doing it since
> the interrupt handler will be triggered as soon as we
> enable the TX
> interrupt. But perhaps we should avoid enabling the
> interrupt and
> schedule the tasklet since we _know_ there's a TX
> interrupt pending?
> 
Ok, you are right, schedule the tasklet is better. I do some
test and post another patch. 

Michael


      Inviato da Yahoo! Mail. 
La casella di posta intelligente.
http://it.docs.yahoo.com/mail/overview/index.html
