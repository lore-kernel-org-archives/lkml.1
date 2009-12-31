Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZLaMeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZLaMeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZLaMef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:34:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:46110 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZLaMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:34:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YiqanKJ+sKDvade8y1rhC6O7twvLRPUYIuxo9QdSms7XgWKpHnRIWnJeR2VPgBrcKQ
         /7lIVypo6RPcD/8AFF+f29b9PS2tVHWx7cy92xuL0ByNr4mKDOFmcDLzSjBcehIj3ART
         U3qLKUnt6Ilp+R0F8Ph4E+pwUGsD+x3LvPfz8=
Message-ID: <4B3C9A53.607@gmail.com>
Date: Thu, 31 Dec 2009 13:34:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-15.2 Thunderbird/3.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: &&/|| confusion in mxser_get_ISA_conf()?
References: <4B3C931A.70104@gmail.com>
In-Reply-To: <4B3C931A.70104@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2009 01:03 PM, Roel Kluin wrote:
> vi drivers/char/mxser.c +2460 and note:
> 
> if ((irq != regs[9]) || (irq != regs[10]))
> 
> Should this be an && ?

I would say not. It's a check whether irq is the same for all chips. It
jumps to a true branch iff at least one irq of the 8 is different (there
are 4 in each register). Does it make sense?

-- 
js
