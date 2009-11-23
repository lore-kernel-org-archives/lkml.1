Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZKWMi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZKWMi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbZKWMi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:38:28 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:39675 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbZKWMi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:38:27 -0500
Message-ID: <4B0A8245.6020506@linux.vnet.ibm.com>
Date: Mon, 23 Nov 2009 10:38:29 -0200
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ben Hutchings <bhutchings@solarflare.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-net-drivers@solarflare.com
Subject: Re: PCI: pci_restore_state() is returning 0 when it fails
References: <4AFD91DD.7000104@linux.vnet.ibm.com> <200911132108.56691.rjw@sisk.pl>  <4B015E0C.9030904@linux.vnet.ibm.com> <1258382974.2841.23.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1258382974.2841.23.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, 

I didn't hear back after the analysis that there is no regression
after this patch. Did you have a chance to think about this patch ?

Thanks
Breno

Ben Hutchings wrote:
> On Mon, 2009-11-16 at 12:13 -0200, Breno Leitao wrote:
>> Hi Rafael, 
>>
>> Rafael J. Wysocki wrote:
>>> On Friday 13 November 2009, Breno Leitao wrote:
>>>> Actually pci_restore_state() is returning 0 if the restore process
>>>> fails, instead of a error value.
>>>>
>>>> If it fails, I believe that it should return -EPERM, once that
>>>> it is an invalid operation and probably pci_save_state() wasn't
>>>> called.
>>> I believe this patch will break a number of things.
>> Well, I checked it, and found that there are around 10 places that
>> really verify the return value for this function, and almost all of them
>> do the correct thing, and the patch doesn't seem to break any of them
>> except a specific case in the drivers/net/sfc/falcon.c file, that contains:
> [...]
>> That's because the code is calling pci_restore_state() twice without calling
>> pci_save_state() in the middle. 
>> Since this seems to be the only place that will be broken, and the fix is
>> trivial, I believe that the patch can be applied smoothly.
> [...]
> 
> This code supports two similar PCI devices, one of which has a second
> function that is not truly independent.  For that chip it saves and
> restores both functions' config space.  So far as I know, there are no
> cases where it fails to match save and restore.
> 
> Ben.
> 
