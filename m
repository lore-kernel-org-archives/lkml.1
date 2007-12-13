Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbXLMWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbXLMWzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbXLMWz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:55:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:44418 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXLMWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:55:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hvLnNS+rVB+PEvJSuVZRleMN4RrNcu6IJFWtXLAD2XVC31/KcBlUSeC0x1JjedNxI/0ToTA/vRvjGQE0KltV70XOl1rMY6CvGVkDkDjbg5sSJdUjjUk+atBrnMVbKxEXRqy6HiuMiKgMZpjdTXmKwMotVh+Qy9+wIw3ZnLqFisw=
Message-ID: <4761B933.4030008@gmail.com>
Date: Thu, 13 Dec 2007 23:58:59 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: auke-jan.h.kok@intel.com, gallatin@myri.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
References: <4761930C.3030504@gmail.com>	<20071213.123727.224454625.davem@davemloft.net>	<4761B219.1030303@gmail.com> <20071213.143425.142750733.davem@davemloft.net>
In-Reply-To: <20071213.143425.142750733.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote, On 12/13/2007 11:34 PM:

> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Thu, 13 Dec 2007 23:28:41 +0100
> 
>> ...I'm afraid I can't understand: I mean doing the same but without
>> passing this info with 'work == weight': if driver sends this info,
>> why it can't instead call something like napi_continue() with
>> this list_move_tail() (and probably additional local_irq_disable()/
>> enble() - but since it's unlikely()?) which looks much more readable,
>> and saves one whole unlikely if ()?
> 
> Because the poll list is private to net_rx_action() and we don't
> want to expose implementation details like that to every
> ->poll() implementation.

So, it seems 'we' failed e.g. exposing napi_complete()...
OK, no offense, I'll only mention at the end that there is
always a possibility to redefine such a function to {} with any
change of implementation.

Jarek P.
