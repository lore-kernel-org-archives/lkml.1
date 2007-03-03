Return-Path: <linux-kernel-owner+w=401wt.eu-S2992961AbXCCDUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992961AbXCCDUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXCCDUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:20:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59651 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992961AbXCCDUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Py6dS07ibU2Z8HemvSgllWTXj8BD9grrXPilCyPJaxhFXcibaDWfdliMtd19tmUgYENtVMdKJuLg7pkCHfPfmCc2y7ZjMslIsvfpuAvAMpFmHurBf2rrIyn5NraoarUKl/pz8FS/xFyKwt/m1w/I8WJ4KbKnauAUMxpIAljMUC8=
Message-ID: <45E8E983.5030109@gmail.com>
Date: Sat, 03 Mar 2007 12:20:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-ide@vger.kernel.org,
       jgarzik@pobox.com, linux-pm@lists.osdl.org, stable@kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 2/2 -stable] libata: add missing CONFIG_PM
 in LLDs
References: <20061122172841.0b90f042@localhost.localdomain>	 <Pine.LNX.4.60.0702262150460.5079@poirot.grange>	 <Pine.LNX.4.60.0702282201250.8832@poirot.grange>	 <Pine.LNX.4.60.0703012305030.7351@poirot.grange>	 <20070302084530.GN20322@htj.dyndns.org>	 <20070302084649.GO20322@htj.dyndns.org> <1172881095.18544.108.camel@nigel.suspend2.net>
In-Reply-To: <1172881095.18544.108.camel@nigel.suspend2.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nigel.

Nigel Cunningham wrote:
>> Index: work1/drivers/ata/ahci.c
>> ===================================================================
>> --- work1.orig/drivers/ata/ahci.c
>> +++ work1/drivers/ata/ahci.c
>> @@ -225,10 +225,12 @@ static void ahci_thaw(struct ata_port *a
>>  static void ahci_error_handler(struct ata_port *ap);
>>  static void ahci_vt8251_error_handler(struct ata_port *ap);
>>  static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
>> +#ifdef CONFIG_PM
>>  static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
>>  static int ahci_port_resume(struct ata_port *ap);
>>  static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
>>  static int ahci_pci_device_resume(struct pci_dev *pdev);
> 
> Wouldn't it be simpler to add
> 
> #else
> #define ahci_port_suspend(port, message) (NULL)
> 
> etc (or something similar)?

ahci_port_suspend() is used to fill ata_port_ops vector, so it needs to
be a function.  If you're talking about defining NULL function, yeah,
that will remove half of CONFIG_PMs but would require dummy definitions
for all functions.  I think both are ugly.  :-)

I'm working on a linker trick.  Please take a look at the following thread.

  http://thread.gmane.org/gmane.linux.ide/16475

-- 
tejun
