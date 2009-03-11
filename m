Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZCKKny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZCKKny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZCKKnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:43:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:27078 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZCKKng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JB6FgFN0gWKpZFadhjnpyQQFav3T87TixIQUplLddOg8XOTH6/Fio09IZVrHuyRoqv
         l/WMdVeZlp7nJSs9GreEjHTGnFjXeC/QNvvun1HIRzWYSw0gTWtogjtiSpvw7+xlB+o0
         NWiWjsIi1avznBDvSYyTFdyIHvxTWqWr+HSa0=
MIME-Version: 1.0
In-Reply-To: <7d86d44a0903110256t11edeff5qfd21055ef047dc2a@mail.gmail.com>
References: <1236756563-20633-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903110057x46cb2aa9p43dd8e12a28be67a@mail.gmail.com>
	 <7d86d44a0903110256t11edeff5qfd21055ef047dc2a@mail.gmail.com>
Date: Wed, 11 Mar 2009 06:43:33 -0400
Message-ID: <8bd0f97a0903110343m1f2f01catbc6cd54ecce91db9@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: Mike Frysinger <vapier.adi@gmail.com>
To: graff yang <graff.yang@gmail.com>
Cc: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, graf.yang@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 05:56, graff yang wrote:
> On Wed, Mar 11, 2009 at 3:57 PM, Mike Frysinger wrote:
>> On Wed, Mar 11, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
>>> +static int __devinit bfin_sir_probe(struct platform_device *pdev)
>>> +{
>>> +       struct net_device *dev;
>>> +       struct bfin_sir_self *self;
>>> +       unsigned int baudrate_mask;
>>> +       struct bfin_sir_port *sir_port;
>>> +       int err;
>>> +
>>> +       err = peripheral_request_list(per[pdev->id], DRIVER_NAME);
>>
>> what if pdev->id is set to 12512 ?
>
> The pdev->id is defined in board files, for example, uart0 should be 0.

so ?  what's to stop the user from setting it to 12415 ?  the driver
must sanity check these things.  you can never assume platform dev
resources always have valid pointers and valid values.

>>> +       switch (max_rate) {
>>> +       default:
>>> +               printk(KERN_WARNING "bfin_sir: Invalid maximum baud rate, using 9600\n");
>>
>> dev_warn(&dev->dev,....) ?
>
> Here the netdev has not been registered.

then use pdev->dev ?
-mike
