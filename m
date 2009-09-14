Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZINNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZINNLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZINNLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:11:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37669 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbZINNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:11:14 -0400
X-Sasl-enc: dxIQpdLE+I6h0mlZQDcQ/yhXtSI2y+bNDicr7pvVUqx1 1252933877
Date: Mon, 14 Sep 2009 10:11:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <teheo@suse.de>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
Message-ID: <20090914131114.GA32253@khazad-dum.debian.net>
References: <d086b110526f8bac2f562850dfc70b03@localhost>
 <4A970154.2020507@redhat.com>
 <4A9B8583.9050601@kernel.org>
 <4A9BBC4A.6070708@redhat.com>
 <4A9BC023.10903@kernel.org>
 <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
 <4AADF471.2020801@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AADF471.2020801@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Tejun Heo wrote:
> Oooh, another possibility is the above continuous IDENTIFY tries.
> Doing things like that generally isn't a good idea because vendors
> don't expect IDENTIFY to be mixed regularly with normal IOs and

IMHO that means the kernel should be special-casing such commands, then (i.e
quiesce drive, do command, quiesce driver, start IO again), probably
rate-limiting it for good effect.

This is the kind of stuff that userspace should NOT have to worry about
(because it will get it wrong and cause data corruption eventually).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
