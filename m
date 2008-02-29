Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbYB2OSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbYB2OSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbYB2OSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:18:47 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:25975 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbYB2OSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xlhMdc15Z3Ew0isef17/pnGfkhhsJTp1yc3ToPalz6ODjcbzXBa+WNJFXZvHM6Ki5w+NURHqfMDVweOcVHAVZxZ8IlkEPXNgqw5H6XjBFG/RNiKVIHQdL9/2woSsHrG1YPbYAEpg81m911neXF5PeutRSR6pN8ujn0vxLNLbC84=
Message-ID: <47C81416.1010305@gmail.com>
Date: Fri, 29 Feb 2008 23:17:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: devres and requesting resources
References: <47C75392.3020606@garzik.org>	<20080229112651.5b2a7f6f@core>	<47C7F664.5040102@garzik.org>	<47C7FA8B.7040306@gmail.com> <20080229140106.41ccc843@core>
In-Reply-To: <20080229140106.41ccc843@core>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> controller like ICH AHCIs.  ata_generic or ide generic might attach to a
>> controller which is already being driven by ahci under certain
>> configurations.
> 
> ata_generic will not nor ata_legacy both are much too smart for that. The
> legacy old IDE driver might but that probably isn't going to be fixed by
> devres and is trivial to fix in that driver (just steal the code from
> pata_legacy).

Yeah, I saw the behavior with ahci + ide generic combination.  I think
it was on SB600.  Heh... neat trick in pata_legacy().  Hmm... it's
probably better to do at generic device level and with a generic helper.

>> have different requirements can just open code pci_request_regions() and
>> pcim_iomap().  pcim_request_regions() should provide sensible default
>> behavior for common cases.
> 
> Which is arguably the current behaviour. Changing the behaviour and not
> the name is a really bad idea and will cause problems in future so don't
> do that.
>> I think the best solution is to allow duplicate request regions for
>> managed devices which is okay as we know we're holding the resource and
>> let drivers which need to reserve all regions call pci_request_regions()
>> before calling pcim_request_regions().
> 
> How about
> 
> 	pcim_request_all_regions()
> 
> for the behaviour Jeff wants, simple, direct, differently named and
> obvious what it does.

Sounds good to me.  Jeff?

-- 
tejun
