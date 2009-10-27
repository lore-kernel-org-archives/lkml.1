Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZJ0KY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZJ0KY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZJ0KY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:24:59 -0400
Received: from gateway-1237.mvista.com ([206.112.117.35]:58726 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752760AbZJ0KY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:24:58 -0400
Message-ID: <4AE6CA70.3000002@ru.mvista.com>
Date: Tue, 27 Oct 2009 13:24:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
Cc: David Miller <davem@davemloft.net>, hancockrwd@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ide] : Increase WAIT_DRQ to support slow CF cards
References: <51f3faa70910261807h54f05f73j48b67067ee3dde70@mail.gmail.com> <20091026.181922.261475236.davem@davemloft.net> <51f3faa70910261840v16444067uc323de7129b7592f@mail.gmail.com> <20091026.184318.205708741.davem@davemloft.net> <20091027094503.GA3116@frolo.macqel>
In-Reply-To: <20091027094503.GA3116@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Philippe De Muyter wrote:

>> From: Robert Hancock <hancockrwd@gmail.com>
>> Date: Mon, 26 Oct 2009 19:40:03 -0600
>>
>>     
>>> On Mon, Oct 26, 2009 at 7:19 PM, David Miller <davem@davemloft.net> wrote:
>>>       
>>>> Meanwhile we should provide a way for things to work, and
>>>> realistically the only way to do that currently is to bump the
>>>> WAIT_DRQ value to some large number.
>>>>
>>>> And that's exactly the kind of patch I'm willing to accept for this.
>>>>         
>>> I agree, it's sub-optimal but it helps.. if the user wants better
>>> behavior they should a) fix it so that the card isn't using PIO, at
>>> least if it supports DMA and b) not use drivers/ide..
>>>       
>
> Strangely enough, I also had no timeout problem if I started my kernel with
> 'ide=nodma', instead of increasing WAIT_DRQ.

    Hm, interesting...

>  So I surmise that WAIT_DRQ is used in the dma case.
>
>   

   It's used only for the PIO write commands -- see do_rw_taskfile() in 
ide-taskfile.c... DMA commands don't require waiting for BSY=0, DRQ=1 
condition.

> Philippe
>   

WBR, Sergei


