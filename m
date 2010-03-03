Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0CCNkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:40:40 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65475 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0CCNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zte2JglZmfLUAZydDpyvtQR/uwNYQcOBHnagE5mMK6Ov+1bjxsu4b7bpWfU1ymaNvr
         cP+3smSUC5rnexTSDDYGBtvoFN8A04/0yafCtxwAs9uZbpm2SAU5y1avwmjf7A7dIAPK
         bZjsQr2ELh6woFAsWciUUIKtaEw+XY1ujvliE=
Message-ID: <4B8E66CE.7070608@garzik.org>
Date: Wed, 03 Mar 2010 08:40:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/12] ahci: Add support for non-PCI devices
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru> <4B8D846F.3080400@garzik.org> <20100303131504.GA25973@oksana.dev.rtsoft.ru>
In-Reply-To: <20100303131504.GA25973@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 08:15 AM, Anton Vorontsov wrote:
> On Tue, Mar 02, 2010 at 04:34:39PM -0500, Jeff Garzik wrote:
> [...]
>> As demonstrated in libata-dev.git#libahci, I think the best route is
>> to move generic code into libahci.  In #libahci you will see
>>
>> 	libahci ->  common code
>> 	ahci ->  standard PCI driver, req's libahci
>> 	mv-ahci ->  Marvell AHCI driver, req's libahci
>> 	acard-ahci ->  ACard AHCI driver, req's libahci
>>
>> and to this we could easily add
>>
>> 	platform-ahci ->  platform AHCI driver, req's libahci
>>
>> WARNING:  #libahci should not be used directly, it is meant for
>> illustration purposes only.  It has not been properly updated for
>> several recent ahci.c changes upstream, which implies that the
>> trivial-and-obvious task of moving generic code from ahci.c to
>> libahci.c must be redone.
>
> Well, do I understand correctly that the only issue is the
> file names? I.e. in my patches, instead of keeping the library
> code in ahci.c, I should move the library code into libahci.c,
> and keep the PCI code in ahci.c?
>
> Because, as far as I can see, the result of my patches is pretty
> much the same as in #libahci, except the file names and more
> things that can be reused (i.e. ahci_sht, ahci_ops -- I kept
> all this in the library part, since we want to share it with
> the platform driver).
>
> Also, I don't export function that aren't currently used
> by PCI or platform drivers, but in #libahci there are all
> exported. Should I keep it my way, or should I export all the
> functions (even if there are no any users of these)?

Well, the general idea is to have a kernel module libahci.ko, upon which 
ahci.ko, mv-ahci.ko, acard-ahci.ko and platform-ahci.ko depends.  That 
would imply a bunch of exports, when the library code is moved from 
ahci.c to libahci.c, because libahci should be a separate kernel module.

I'm not overly picky about file naming.  However, in existing 
installations, people, scripts, knowledgebase articles and configuration 
files expect "ahci" to be the driver for PCI AHCI devices.  We don't 
want to break that if we can avoid it.  Simply using a different name 
avoids any breakage related to name changes.

	Jeff



