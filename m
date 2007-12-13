Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbXLMWZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbXLMWZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXLMWZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:25:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:62535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbXLMWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MAAG/hTyp0FfO6E0DSxMok8UZyM/gZjHuE4phZgeNbf/oJTVM8Ko1vauozdnVR/Tkr7mRG2IwCw9rETz4vEafF0JZqFKAA/6WOHVRfNycoh/tAssYsKzWxJcqij6Mi3Bvk5P0YroFVC/1vZdMWc1I9YKJndquKnHmsXfpIe99zk=
Message-ID: <4761B219.1030303@gmail.com>
Date: Thu, 13 Dec 2007 23:28:41 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: auke-jan.h.kok@intel.com, gallatin@myri.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
References: <20071213134953.GA3806@ff.dom.local>	<20071213.055013.83963139.davem@davemloft.net>	<4761930C.3030504@gmail.com> <20071213.123727.224454625.davem@davemloft.net>
In-Reply-To: <20071213.123727.224454625.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote, On 12/13/2007 09:37 PM:
...

> For example, if we export the list handling widget into the ->poll()
> routines, god help the person who wants to change how the poll list is
> managed in net_rx_action() :-/

...I'm afraid I can't understand: I mean doing the same but without
passing this info with 'work == weight': if driver sends this info,
why it can't instead call something like napi_continue() with
this list_move_tail() (and probably additional local_irq_disable()/
enble() - but since it's unlikely()?) which looks much more readable,
and saves one whole unlikely if ()?

Jarek P.
