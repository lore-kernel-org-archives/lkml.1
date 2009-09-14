Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZINHoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZINHoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZINHow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:44:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:35358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZINHov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:44:51 -0400
Message-ID: <4AADF471.2020801@suse.de>
Date: Mon, 14 Sep 2009 16:44:49 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
       Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org>
In-Reply-To: <4AADF3C4.5060004@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> I wonder what's different about these two timeouts such that one causes an I/O
>> error and the other just causes a retry after reset? Presumably if the latter
>> was also just a retry, everything would be (closer to being) fine.
> 
> Because this error is actually seen by the md layer and FLUSH in
> general can't be retried cleanly.  On retrial, the drive goes on and
> retry the sectors after the point of failure.  I'm not sure whether
> FLUSH is actually failing here or it's a communication glitch.  At any
> rate, if FLUSH is failing or timing out, the only right thing to do is
> to kick it out of the array as keeping after retrying may lead to
> silent data corruption.  Seriously, it's most likely a hardware
> malfunction although I can't tell where the problem is with the given
> data.  Get the hardware fixed.

Oooh, another possibility is the above continuous IDENTIFY tries.
Doing things like that generally isn't a good idea because vendors
don't expect IDENTIFY to be mixed regularly with normal IOs and
firmwares aren't tested against that.  Even smart commands sometimes
cause problems.  So, finding out the thing which is obsessed with the
identity of the drive and stopping it might help.

Thanks.

-- 
tejun
