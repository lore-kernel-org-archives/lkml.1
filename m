Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbXEVVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbXEVVXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbXEVVXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:23:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:38030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbXEVVXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:23:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LpZIAJWI3Ncd3Js3bC0F5Ls8D7jFbYwjbRqP8BAXPJ88GoCIjeQaZ5UD+uaZEHEWis/mfLJPKLEWvAjWQrtGb2frGDs5OKx6uoCjYMysd60VjhXxg33NnMrF1mfFfwq0zqfTvemKggq9tYcV0wMcdOXrqCnMd+OwYAb5/JqntaI=
Message-ID: <46535F56.1010009@gmail.com>
Date: Tue, 22 May 2007 23:23:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: use mutex instead of semaphore in RocketPort driver
References: <200705081903.l48J3lr1012622@hera.kernel.org> <1179853142.3296.1.camel@laptopd505.fenrus.org> <20070522200601.GG22360@traven> <46535AD3.9060904@simon.arlott.org.uk>
In-Reply-To: <46535AD3.9060904@simon.arlott.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott napsal(a):
> On 22/05/07 21:06, Matthias Kaehlcke wrote:
>> would the following resolve the problem?
>>
>> if(mutex_lock_interruptible(&info->write_mtx))         return
>> -ERESTARTSYS
>>
>> thanks for your comments
>>
> 
> No. At least one user of tty_operations/tty_driver's write function
> doesn't check the return value so it would never be retried, mutex_lock
> should be used instead.

Who? There are some drivers that returns ERESTARTSYS from write function.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
