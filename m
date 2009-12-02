Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZLBPDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZLBPDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZLBPDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:03:10 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:61940 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZLBPDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=i0ja4Qn9ggwh7X/4UWA/uXq0YayQFEhHVSl1zRmCgmbcGvKvG32C+vgIBJFUq9ZHaC
         sN8oUFVrntCpKKUG3oqRr8XM56CpTZTWbh8dhL400YkSlmhoC8BOmwMiz3IDHYEhMyqJ
         DDH7+EWaRqfS6keX9o6LxB5oIj3WeutKHGtLE=
MIME-Version: 1.0
In-Reply-To: <20091202110326.GZ14091@buzzloop.caiaq.de>
References: <1259687838-31722-1-git-send-email-daniel@caiaq.de> 
	<f17812d70912011650h48a6c391s426ffc8b4b653fc8@mail.gmail.com> 
	<20091202110326.GZ14091@buzzloop.caiaq.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 2 Dec 2009 23:02:55 +0800
Message-ID: <f17812d70912020702n318089f0rd2e129b0e45458b2@mail.gmail.com>
Subject: Re: [PATCH] mmc: pxamci: call mmc_remove_host() before freeing 
	resources
To: Daniel Mack <daniel@caiaq.de>
Cc: Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 7:03 PM, Daniel Mack <daniel@caiaq.de> wrote:
> On Wed, Dec 02, 2009 at 08:50:44AM +0800, Eric Miao wrote:
>> On Wed, Dec 2, 2009 at 1:17 AM, Daniel Mack <daniel@caiaq.de> wrote:
>> > mmc_remove_host() will cause the mmc core to switch off the bus power by
>> > eventually calling pxamci_set_ios(). This function uses the regulator or
>> > the GPIO which have been freed already.
>> >
>> > This causes the following Oops on module unload.
>> >
>
> [...]
>
>> >
>> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
>> > Reported-by: Sven Neumann <s.neumann@raumfeld.com>
>> > Cc: Pierre Ossman <pierre@ossman.eu>
>> > Cc: Eric Miao <eric.y.miao@gmail.com>
>> > Cc: linux-mmc@vger.kernel.org
>> > Cc: linux-arm-kernel@lists.infradead.org
>> > Cc: stable@kernel.org
>> > ---
>> >  drivers/mmc/host/pxamci.c |    4 ++--
>>
>> Looks like a correct fix to me.
>>
>> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
> Would be good to still get this into .32 - who will take care of picking
> this?
>

I'll send a pull request, and see if Russell will be happy to send
another one in such a short time :)
