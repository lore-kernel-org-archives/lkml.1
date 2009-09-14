Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZINNFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZINNFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZINNFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:05:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZINNFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:05:17 -0400
Message-ID: <4AAE3F86.8090804@suse.de>
Date: Mon, 14 Sep 2009 22:05:10 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca>
In-Reply-To: <4AAE3B9A.2060306@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
> ..
>> Oooh, another possibility is the above continuous IDENTIFY tries.
>> Doing things like that generally isn't a good idea because vendors
>> don't expect IDENTIFY to be mixed regularly with normal IOs and
>> firmwares aren't tested against that.  Even smart commands sometimes
>> cause problems.  So, finding out the thing which is obsessed with the
>> identity of the drive and stopping it might help.
> ..
> 
> Bullpucky.  That sort of thing, specifically with IDENTIFY,
> has never been an issue.

With SMART it has.  I wouldn't be too surprised if some new firmware
chokes on repeated IDENTIFY mixed with stream of NCQ commands.  It's
just not something people (including vendors) do regularly.

> I wonder if the IDENTIFY is actually coming from libata EH
> after something else failed ?

In that case, libata-eh would print "ataP.DD: failed to IDENTIFY
(blah, err_mask=0x%x\n" instead of the full TF dump.

Thanks.

-- 
tejun
