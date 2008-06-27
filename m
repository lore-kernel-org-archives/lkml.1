Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYF0HTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYF0HTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYF0HTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:19:04 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32752 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754414AbYF0HTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:19:03 -0400
Message-ID: <4864944B.5020601@panasas.com>
Date: Fri, 27 Jun 2008 10:18:35 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: keyspan_pda.c use of keyspan_pda_get_modem_info
References: <4863AD33.3070005@panasas.com> <20080626162346.5c324701@lxorguk.ukuu.org.uk> <20080627041735.GB8145@kroah.com>
In-Reply-To: <20080627041735.GB8145@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 07:18:37.0124 (UTC) FILETIME=[0438B040:01C8D826]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun. 27, 2008, 7:17 +0300, Greg KH <greg@kroah.com> wrote:
> On Thu, Jun 26, 2008 at 04:23:46PM +0100, Alan Cox wrote:
>>> In these two call sites the callers bail out if
>>> keyspan_pda_get_modem_info return value is < 0
>> I don't think that is what the compiler is warning about.
>>
>> We error on rc < 0
>> We use the returned status on rc >= 0
>>
>> We set the returned status on rc > 0
>>
>> So the rc = 0 case is broken and gcc seems to be correct about that
> 
> Yes, that is correct, fortunatly that function can never return rc = 0,
> so this will not happen in real life.
> 
> But there is really no way the compiler can ever figure that out, so I
> don't blame it for complaining.
> 
> If you want to make a simple patch to make the compiler happy and be
> quiet about the warning, I'll take it.

Cool. I'll send a patch initializing status to 0.
Now, what about the rc == 0 case?
Does it warrant a BUG_ON() if it should ever happen?

Benny

> 
> thanks,
> 
> greg k-h

