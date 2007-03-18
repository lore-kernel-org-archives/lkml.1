Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbXCRFsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbXCRFsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXCRFsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:48:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:34134 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXCRFsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ITgoj9SQ80NVHXNS1LGlF0BUkSHcZChRU0fSQ9OApbtph19erCsHavrDSrvOldTs+GyzVObzF6tXu2AdRmEywGBau5QZBZyD8quXiOMt1RrrlxxaS33GoAp1J/DRe+ISKuBugBeNrL6+z4bB7IxpfwKze1YdS/YJBFZWkZUV1gU=
Message-ID: <45FCD2AF.90909@gmail.com>
Date: Sun, 18 Mar 2007 14:48:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Komuro <komurojun-mbn@nifty.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: libata reports bogus addresses for everything (was PATA_PCMCIA
  cmd port)
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>	<20061217040222.GD17561@ftp.linux.org.uk>	<20070211101537.e40fa309.komurojun-mbn@nifty.com>	<20070317220050.380d9f51.komurojun-mbn@nifty.com> <20070317154333.088d77d4@lxorguk.ukuu.org.uk>
In-Reply-To: <20070317154333.088d77d4@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 17 Mar 2007 22:00:50 +0900
> Komuro <komurojun-mbn@nifty.com> wrote:
> 
>> Hi,
>>  
>> The pata_pcmcia driver reports the cmd port is 0x00010100,
>> but actually the cmd port is 0x0100.
>>
>> Is this corect?
> 
> When the pci_iomap patches were applied the ports reported for every
> device went strange.  It appears to display the wrong information
> nowdays. I see the same but I've got many more important things to work
> on before I even bother to look at it.
> 
> My guess is someone is now printing the iomap virtual addresses not the
> bus ones.

Yes, we're printing the ioaddr.* directly and those are all iomapped
addressed now.  I wonder whether we should fix this or push the port
printing to LLDs (with sff helpers in libata-sff).  ahci and
pata_generic sharing one format doesn't sound like a too good idea.
I'll fix it after new init model.

-- 
tejun
