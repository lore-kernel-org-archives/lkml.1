Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385Ab0AUFAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab0AUFAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981Ab0AUFAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:00:12 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:57473 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0AUFAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cTuJNYBfJbl9qgKUD/1rXxHKotBkXtQlqf7KOJEZJ1BztADlnfdGywokxijUXayz79
         rozomzazIzXWhuKv5tF5+JLee5E550k6eYHM910AAIkBA9vhJ2ttXufdNz8EDX/AUBUp
         w8/U/nTVjWujICShhJqo1q8GltQBEF6x8OLHM=
Message-ID: <4B57DF52.2030906@garzik.org>
Date: Thu, 21 Jan 2010 00:00:02 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
References: <m33a4nfvva.fsf@intrepid.localdomain>	<201001141659.19687.bzolnier@gmail.com>	<20100114192210.62593ead@lxorguk.ukuu.org.uk>	<201001142129.38781.bzolnier@gmail.com> <20100114210050.2c99c2b1@lxorguk.ukuu.org.uk>
In-Reply-To: <20100114210050.2c99c2b1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 04:00 PM, Alan Cox wrote:
>> I think that you misinterpreted the issue -- according to Krzysztof MMIO
>> works just fine, only 8/16-bit MMIO reads are a problem (please note that
>> using mixed PIO/MMIO access is still a win over pure PIO access and also
>> that sata_sil doesn't support pure non-MMIO operations currently)..
>
> Have we got timing measurements to prove that ?
>>
>> However if it gets fixed in the upstream kernel in some other way I'll
>> simply drop the patch during the next re-base of my tree (I just collect
>> ATA stuff that looks useful/interesting to me and which otherwise may
>> become lost)..
>
> And that's a good thing. The question was aimed at Krzysztof. Really we
> need to keep platform specific weirdness out of core drivers or the
> rapidly turn into a mess.

The lack of 8-/16-byte MMIO access is unfortunately not limited to 
Krzysztof's platform.  Other people have reported the same problem 
specifically with sata_sil (see the archives).

If the driver cannot be converted to all-32-bit accesses, we will need 
to do something like Krzysztof's patch.

	Jeff




