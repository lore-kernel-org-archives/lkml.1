Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYDYIUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYDYIUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYDYITx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:19:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:47563 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYDYITi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TQi7Td4fWO+WDimwfNPhs7TqaJDJGXCfNicOS+Q8BeM14BhrPI0O1KTnIgCKrWtMw3rHYnXBbmiNM104R8Dz8suovTl9cTbF53RfLU8zlMQkBJxr638ZelrdnNBkTOO0BAykXK8KZ5blD9W1HMEaSe0fG1f+l1xFlfhdMCoHdlc=
Message-ID: <481193EF.9050308@gmail.com>
Date: Fri, 25 Apr 2008 10:18:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: pci commands resume order [Was: 2.6.25-git2: BUG: unable to handle
 kernel paging request at ffffffffffffffff]
References: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org>	<20080424.185757.254044977.davem@davemloft.net>	<48118B18.5020008@gmail.com> <20080425.004523.146850490.davem@davemloft.net>
In-Reply-To: <20080425.004523.146850490.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2008 09:45 AM, David Miller wrote:
> I notice Jiri, in your hardware list, you have an ath5k Atheros AR5212 chip
> in there.
> 
> I took a look at the resume code for ath5k but nothing really suspicious
> there except:
> 
> 	err = pci_enable_device(pdev);
> 	if (err)
> 		return err;
> 
> 	pci_restore_state(pdev);
> 
> Shouldn't we restore state before we turn the chip back on and thus
> potentially let it start DMA'ing all over the place?

Hmm, actually every second wireless driver do this :/. I think it's wrong too.
Jesse?

BTW pci_set_power_state(pdev, PCI_D0); in resume isn't needed at all, right? 
It's done in pci_enable_device, isn't it?
