Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbZLOXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbZLOXJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbZLOXJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:09:10 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:51502 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbZLOXJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:09:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wdW9zv4AOdMdx2PgerXMpM9x+wNzB8B6ce3luLW7+15/Xdcr1+VePzBXhDBqAWHvs+
         i53lAvZ8b1CF9mJxzXFSZ/M3GItt8noj+AEezrrlsOuYNDjkJeSqvntmU1PyevTTiQMZ
         kAYHI4YFo86y9MR0XIReBTqFht+zHvTdQrMag=
Message-ID: <4B28170F.9010808@pobox.com>
Date: Tue, 15 Dec 2009 18:09:03 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL: Add a work-around for IXP4xx CPU.
References: <m3fx8m0vwh.fsf@intrepid.localdomain> <4B274694.6020701@kernel.org> <m3hbrrc013.fsf@intrepid.localdomain>
In-Reply-To: <m3hbrrc013.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 06:03 PM, Krzysztof Halasa wrote:
> Tejun Heo<tj@kernel.org>  writes:
>
>> Hmmm... Given that there are some platforms which have problem with
>> mmio and sil3112/4 can do everything via io accesses, it would be nice
>> to generalize this so that there's CONFIG_SATA_SIL_NO_MMIO which is
>> selected by affected platforms.  Are you interested in doing it?
>
> Unfortunately I no longer have access to that SIL3512 miniPCI card so
> I wouln't be able to test on IXP425. Perhaps it's not a problem, testing
> on i386 (probably with disabled MMIO BAR) should be enough.
>
> OTOH IIRC SIL3x12 needs to use the MMIO write to start BM DMA, otherwise
> the AT-style 64 KB limits apply. I think IXP4xx would benefit from only
> ioread8() going through normal IO.
>
> Do you know what platforms have the MMIO problems? What kind of problems
> are there, inability to use MMIO at all? (IXP4xx can't do 8/16-bit MMIO
> reads).

The inability to do 8/16-bit MMIO reads are a repeated sticking point 
with embedded scenarios.  That's it.

I keep meaning to give the docs a hard look, and see if we can combine 
multiple taskfile register reads/writes into a single 32-bit one.  That 
would solve all these problems, without having to resort to the use of 
standard BARs.

	Jeff



