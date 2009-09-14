Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZINNYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZINNYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZINNYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:24:49 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:34793 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZINNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:24:48 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 09:24:48 EDT
Date: Mon, 14 Sep 2009 15:14:38 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Message-ID: <20090914131438.GD14072@boogie.lpds.sztaki.hu>
References: <1571f45804875514762f60c0097171e6@localhost>
 <d086b110526f8bac2f562850dfc70b03@localhost>
 <4A970154.2020507@redhat.com>
 <4A9B8583.9050601@kernel.org>
 <4A9BBC4A.6070708@redhat.com>
 <4A9BC023.10903@kernel.org>
 <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AADF3C4.5060004@kernel.org>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 04:41:56PM +0900, Tejun Heo wrote:

> Because this error is actually seen by the md layer and FLUSH in
> general can't be retried cleanly.  On retrial, the drive goes on and
> retry the sectors after the point of failure.  I'm not sure whether
> FLUSH is actually failing here or it's a communication glitch.  At any
> rate, if FLUSH is failing or timing out, the only right thing to do is
> to kick it out of the array as keeping after retrying may lead to
> silent data corruption.

Hmm, how's that supposed to work with TLER on WD enterprise drives?
Isn't the idea behind TLER to prevent drives being kicked out of the
array because the RAID system can have a much more intelligent
retry/recovery logic than a single drive?

AFAIK md RAID can already take advantage of TLER if the operation that's
failing due to TLER is a READ, but I don't know what happens if TLER
kicks in during a WRITE or a FLUSH.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
