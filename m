Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYITOiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYITOiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYITOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:37:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32006 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYITOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jKWfE+Y74NIlatKuMpUTlmVWuzOQh2y+t+K/kAs2J+dN2ZStJqCI/3ep5bpyyE5eNh
         HyxOWTIyrBsPs1vv6DL7PdejVea4D2LtB79YOXUGKDs8on9CbjUrwVvkZohXp+X5Y9JJ
         XrehUyYUZ3qJKgY1shaIa3pMyXQaTsfSQh52U=
Message-ID: <cabda6420809200737r7750878x3e013e177ca23304@mail.gmail.com>
Date: Sat, 20 Sep 2008 16:37:52 +0200
From: chri <chripell@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] max3100 driver
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <20080920151149.21dbad1d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221895208650-git-send-email-chripell@gmail.com>
	 <20080920151149.21dbad1d@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 4:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> +#define MAX3100_MAJOR 204
>> +#define MAX3100_MINOR 128
>> +/* 4 MAX3100s should be enough for everyone */
>> +#define MAX_MAX3100 4
>
> These need to be officially allocated if you need constant numbers
>

OK, I'll try to mail device@lanana.org


>
>> +             if (rxchars > 0)
>> +                     tty_flip_buffer_push(s->port.info->port.tty);
>> +             if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
>
> If there has been a hangup the port.tty will be NULL...
>

I didn't notice an explicit test for port.tty being non-NULL in some
drivers. I took as an example sa1100 driver (since it needs polling of
control signals too). I'm missing the way these drivers take care to
not cause an access of a NULL pointer?

>
> Looks basically sound to me - just some minor cleanups needed.
>

Thanks, I will fix them and resubmitt


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
