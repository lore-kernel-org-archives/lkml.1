Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbYEVD7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbYEVD7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYEVD7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:59:40 -0400
Received: from mga06.intel.com ([134.134.136.21]:53774 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbYEVD7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:59:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,523,1204531200"; 
   d="scan'208";a="283823780"
Message-ID: <4834EFA9.6050407@linux.intel.com>
Date: Wed, 21 May 2008 20:59:37 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] serial: fix enable_irq_wake/disable_irq_wake imbalance
 in serial_core.c
References: <20080519201141.1dbe6cc1@linux.intel.com> <20080521145338.022abd3b.akpm@linux-foundation.org>
In-Reply-To: <20080521145338.022abd3b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>  	}
>>  
>> -	if (!port->suspended) {
>> +	tty_dev = device_find_child(port->dev, &match, serial_match_port);
>> +	if (!port->suspended && device_may_wakeup(tty_dev)) {
>>  		disable_irq_wake(port->irq);
>>  		mutex_unlock(&state->mutex);
>>  		return 0;
> 
> erp, is that the easiest way of going from a uart_driver* to a device*?
> Doing a lookup each time is a bit unusual.
> 

this is during suspend/resume only, so I figured it wasn't going to be that performance critical;
I wanted the code to be as symmetric as possible rather than fastest..
