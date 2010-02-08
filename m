Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0BHSrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:47:21 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:64400 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0BHSrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jm6i8g1Gqma5/wRzW56uaH28nOdh8EqpOGTxpdHBn+eMKuneM8vZs2Cr033lfs6pLU
         wNZmgYMWtM2lZbxCo+HzKMc/a75CDLrmGt+/RxTFD3SUxFC5jcxHTuGYqCVsgeCKD/gV
         alyftsNlZvIigTP4bQlxiE041ApA2qJg+vNiI=
MIME-Version: 1.0
In-Reply-To: <20100208184338.GA17495@emergent.ellipticsemi.com>
References: <45c77aec1002071056re61b8acg5f480f8ea83c68c@mail.gmail.com>
	 <d45a3acc1002071414q318edea3m38f6d5ddbbd841bc@mail.gmail.com>
	 <45c77aec1002081013q2b07cb7flbd827a977ed51d4c@mail.gmail.com>
	 <20100208184338.GA17495@emergent.ellipticsemi.com>
Date: Mon, 8 Feb 2010 13:47:17 -0500
Message-ID: <45c77aec1002081047t48ff5d9dp31c4b7352f61758e@mail.gmail.com>
Subject: Re: Possible bug in insmod or the kernel?
From: Larry Homes <larr.homes@gmail.com>
To: Larry Homes <larr.homes@gmail.com>,
       andrew hendry <andrew.hendry@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was it. The shell was eating the quotes. Thanks alot!

On Mon, Feb 8, 2010 at 1:43 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 13:13 Mon 08 Feb     , Larry Homes wrote:
>> No, the problem is not that the quotes are showing. The problem is
>> that as soon as it sees a space, it assumes the following is the next
>> parameters name. So for example:
>>
>> [root@myhost modules]# insmod hello3.ko name="john smith"
>> insmod: error inserting 'hello3.ko': -1 Unknown symbol in module
>>
>> [root@myhost modules]# insmod hello3.ko "name=john smith"
>> insmod: error inserting 'hello3.ko': -1 Unknown symbol in module
>>
>> In both cases, dmesg shows:
>>
>> hello3: Unknown parameter `smith'
>>
>> I looked at the params.c code and it seems like the above should work.
>
> I'm not familiar with the code in question, but I suspect that it
> expects to actually see the quotation marks in the parameter value, but
> your shell is eating them.  Try
>
>  insmod hello3.ko 'name="john smith"'
>
> instead.
>
> --
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
>
