Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZJYQhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZJYQhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZJYQhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:37:53 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:42980 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZJYQhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TQp3kAI/TB2EsSlTO/qw9pg+MjCvcTXXwJtIM4b2JpTkA/uNbR0Ot2O5Nz3MGu6a6c
         iRFD3nud/9ZRkboOzkrvuASbtadyo+rsT9Z93zz+gddmBr76Zov4DaHH7HjreUOZRjXt
         GOvdu4VBqUmXJ8FM0QXJcvdwH8x1nYLCDnZZY=
MIME-Version: 1.0
In-Reply-To: <20091025162019.GA10898@khazad-dum.debian.net>
References: <b8bf37780910250618h3edce547y41a8dd03e4fb4e71@mail.gmail.com>
	 <20091025162019.GA10898@khazad-dum.debian.net>
Date: Sun, 25 Oct 2009 14:37:57 -0200
Message-ID: <b8bf37780910250937x14b8f008xd8443fe004749403@mail.gmail.com>
Subject: Re: [PATCH 2/2] serial: cascade needless conditionals
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: gregkh@suse.de, alan@linux.intel.com,
       Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Henrique!

On 10/25/09, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Sun, 25 Oct 2009, André Goddard Rosa wrote:
>>  	if (flags == UPF_SPD_HI)
>>  		altbaud = 57600;
>> -	if (flags == UPF_SPD_VHI)
>> +	else if (flags == UPF_SPD_VHI)
>>  		altbaud = 115200;
>> -	if (flags == UPF_SPD_SHI)
>> +	else if (flags == UPF_SPD_SHI)
>>  		altbaud = 230400;
>> -	if (flags == UPF_SPD_WARP)
>> +	else if (flags == UPF_SPD_WARP)
>>  		altbaud = 460800;
>
> This changes code behaviour if more than one bit is set (which might never
> happen for all I know...).  You should invert the order of the tests if you
> want to make sure it is side-effect-free.
>

Do you mind explaining why? Notice that it's not (var & flag), it's =='.
Can flags be equal more than one flag at the same time?

Thanks,
André
