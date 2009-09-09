Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZIIBCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZIIBCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZIIBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:02:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZIIBCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:02:48 -0400
Message-ID: <4AA6FE42.9070700@zytor.com>
Date: Tue, 08 Sep 2009 18:00:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Richard Kettlewell <rjk@terraraq.org.uk>
Subject: Re: [PATCH] x86: Fix code patching for paravirt-alternatives on 486
References: <1252452228.3423.121.camel@localhost>	 <4AA6F777.2080103@zytor.com> <1252457195.3423.124.camel@localhost>
In-Reply-To: <1252457195.3423.124.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 05:46 PM, Ben Hutchings wrote:
> On Tue, 2009-09-08 at 17:31 -0700, H. Peter Anvin wrote:
> [...]
>> I'm wondering if it wouldn't be cleaner to fold the jump into
>> sync_core() and moving the sync_core() up before local_irq_restore().
> 
> Exactly as I suggested below the dashes. :-)
> 

Ah, yes, so you did indeed.

> The only reason I didn't do that initially was that I don't know whether
> or not there's a good reason for the current placement of sync_core()
> after local_irq_restore().

I can personally not fathom how moving the sync_core() before
local_irq_restore() could cause problems -- in fact, the current code
seems logically wrong, although probably correct in practice, as the
interrupt itself should perform the necessary synchronization (although
it is not architecturally required to do so.)  Not that I haven't been
wrong before.

	-hpa
