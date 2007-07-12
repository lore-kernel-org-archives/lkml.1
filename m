Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbXGLLaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbXGLLaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 07:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbXGLLaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 07:30:05 -0400
Received: from emulex.emulex.com ([138.239.112.1]:58940 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXGLLaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 07:30:03 -0400
Message-ID: <4696107C.60104@emulex.com>
Date: Thu, 12 Jul 2007 07:29:00 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Pcihpd-discuss] [PATCH 26/34] PCI: add pci_try_set_mwi
References: <11841968092270-git-send-email-gregkh@suse.de>	<11841968133805-git-send-email-gregkh@suse.de>	<11841968172168-git-send-email-gregkh@suse.de>	<11841968221388-git-send-email-gregkh@suse.de>	<11841968302709-git-send-email-gregkh@suse.de>	<11841968341206-git-send-email-gregkh@suse.de>	<11841968561560-git-send-email-gregkh@suse.de>	<11841968591561-git-send-email-gregkh@suse.de>	<11841968633587-git-send-email-gregkh@suse.de>	<20070712000149.GX9704@parisc-linux.org>	<20070712003731.GA8126@kroah.com> <20070711201229.43b71681.randy.dunlap@oracle.com>
In-Reply-To: <20070711201229.43b71681.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2007 11:29:00.0671 (UTC) FILETIME=[D7F5C8F0:01C7C477]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm agnostic on the change... As long as we get a message somewhere
when the failure is meaningful, I'm fine with this change. I didn't
like setting mwi by the driver anyway - it should have already been
done by the platform.

-- james s


Randy Dunlap wrote:
>>>> --- a/drivers/scsi/lpfc/lpfc_init.c
>>>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>>>> @@ -1578,10 +1578,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
>>>>  	INIT_LIST_HEAD(&phba->fc_nodes);
>>>>  
>>>>  	pci_set_master(pdev);
>>>> -	retval = pci_set_mwi(pdev);
>>>> -	if (retval)
>>>> -		dev_printk(KERN_WARNING, &pdev->dev,
>>>> -			   "Warning: pci_set_mwi returned %d\n", retval);
>>>> +	pci_try_set_mwi(pdev);
>>> Why remove the warning?  Presumably people want to know if pci_set_mwi
>>> failed.
>> Randy, this was your change, right?
> 
> Uh, I think that my thinking was like this:
> 
> pci_try_set_mwi() and pci_set_mwi() are both "try best effort"
> functions.  Neither of them guarantees that pci_set_cacheline_size()
> will succeed.  And in case of serious problems, pci_set_cacheline_size()
> will print a (KERN_DEBUG) message.
> 
> 
> Anyway, I don't mind restoring the former lpfc code if that is what
> should be done.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
