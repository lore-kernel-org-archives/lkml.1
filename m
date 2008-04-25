Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbYDYIC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbYDYIC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbYDYICI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:02:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10866 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYDYICF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HbY1uP6NuI9t2Zj5030dVxEwH2cN5rPYdQVBsLQTRhpTYRtlcBooqkQp3eGHAf5/VB4APrN4QExa3ygCvbWBkH9dI0QgjZoppIUf8fTla319IBpwcKXmboLYnQASom0vIBB9MSRa9SzByQhWQL8BLhEV7MY53bb9FdfXrjWCik0=
Message-ID: <48118FF8.2080204@gmail.com>
Date: Fri, 25 Apr 2008 10:02:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
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

Hmm, I cut&pasted that code from somewhere, it seems to be broken. Anyway it 
worked for a half a year or so. Mending locally. Thanks.
