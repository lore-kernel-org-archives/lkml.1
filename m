Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbZEZXpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbZEZXpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbZEZXpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:45:03 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:53042 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbZEZXpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JSVzl0+Mr5MsnMseVsGfDK6J+RwqiKT98MyNbaN02mRVzT4I63hii+lp33kE0AmNdo
         L5LhAXOElm5OxVvimowmWXVirlNoyQEPWHWxXYudvBbHKG+kO2uhm3nQYQ03E9apY0l5
         UMaHYtMnrWfgPELh3RyzVdsp9cz9WJMB493j0=
Message-ID: <4A1C7EF9.2030000@gmail.com>
Date: Tue, 26 May 2009 17:44:57 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       towerlexa@gmx.de
Subject: Re: Who's responsible for configuring CLS on a cardbus device?
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090526142300.73d466d0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 26 May 2009 22:05:08 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Hello,
>>
>> This is regarding bko#13257.
>>
>>  http://bugzilla.kernel.org/show_bug.cgi?id=13257
>>
>> towerlexa@gmx.de was experiencing very slow transfer rate when using a
>> cardbus sata_sil SATA controller which is known to be sensitive to
>> cache line size setting.  The reset default is zero and no one
>> configured it causing poor performance.
>>
>> This is solvable by simply setting CLS to the correct value but who's
>> job is it?  For non-hotplug devices, this is configured by the BIOS
>> (at least on PC), so for hotplug devices I think falls on the lap of
>> the PCI code but I'm not sure.  If this is something which the
>> sata_sil driver should be responsible for, is there an established way
>> to determine the proper CLS value?
> 
> Currently its handled by pci_set_mwi() but there isn't actually a more
> direct way to do this.

Yeah, I guess the assumption is that unless the device is using MWI it 
doesn't care about cache line size. However, in the case of the sata_sil 
controllers (and possibly other devices), the device cares about it for 
other purposes (I think it's FIFO handling in this case).

Maybe we should just be setting the cache line size somewhere more 
basic, like pci_set_master or something?
