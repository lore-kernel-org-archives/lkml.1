Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYGXMFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYGXMFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYGXMFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:05:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:28358 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYGXMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:05:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YUi6qfkHYWIkP2O3wADWTIgvqi0B8bRCNdVCobATG/VVdoeIWRbpR8DX4wDK2F1Zxf
         RyJvcGRvZhjumj2+HMG81k9ZNeHk7gQgVE7tfmcG3cbUnGcsosSkj2ACIJqkqBtuwZz/
         N+LcuJy1bwGqvzvzEFJg8fkX0bYQpK/3fuTLE=
Date: Thu, 24 Jul 2008 16:05:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() smp-safe
Message-ID: <20080724120512.GA21804@lenovo>
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48886E6D.1030005@fujitsu-siemens.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Martin Wilck - Thu, Jul 24, 2008 at 01:58:37PM +0200]
> Cyrill Gorcunov wrote:
>
>> Hi, but what if SMI flood happens? We could stuck here forever, don't we?
>>
>>                 - Cyrill -
>
>
> Yes, if the SMI flood never ends. But you wouldn't want to work on such  
> a system anyway (with the current kernel code, your APIC timer would  
> most probably be miscalibrated, which can have the weirdest effects).
>
> Anyway, we can add a maximum iteration count to the patch so that there  
> is no risk of getting stuck.
>
> Martin
>
> -- 
> Martin Wilck
> PRIMERGY System Software Engineer
> FSC IP ESP DEV 6
>
> Fujitsu Siemens Computers GmbH
> Heinz-Nixdorf-Ring 1
> 33106 Paderborn
> Germany
>
> Tel:			++49 5251 8 15113
> Fax:			++49 5251 8 20209
> Email:			mailto:martin.wilck@fujitsu-siemens.com
> Internet:		http://www.fujitsu-siemens.com
> Company Details:	http://www.fujitsu-siemens.com/imprint.html
>

yes, it will issue some effects but it's better then stuck there.
More over in 'case of SMI flood with current patch you don't get
error message printed i think so you better add max iteration
counter so user will see on console (or whatever) that he is got
problems.
		- Cyrill -
