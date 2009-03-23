Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbZCWVwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbZCWVwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZCWVwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:52:36 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33992 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbZCWVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:52:35 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 7169C3CA5F9
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Barriers still not passing on simple dm devices...
To: Eric Sandeen <sandeen@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       ?missing.closing.'"' in token?"MASON",
	CHRISTOPHER <CHRIS.MASON@oracle.com>"@vax.1wt.eu
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"MASON", CHRISTOPHER <CHRIS.MASON@oracle.com>"
			^				    ^-missing closing '"' in token
		 \-extraneous tokens in address
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
	To:	?missing closing '"' in token?"MASON", CHRISTOPHER <CHRIS.MASON@oracle.com>"
			^				    ^-missing closing '"' in token
		 \-extraneous tokens in address
Reply-To: 7eggert@gmx.de
Date: Mon, 23 Mar 2009 22:52:31 +0100
References: <ciXHh-39c-37@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Lls4N-0001LL-Pz@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@redhat.com> wrote:

> I've noticed that on 2.6.29-rcX, with Andi's patch
> (ab4c1424882be9cd70b89abf2b484add355712fa, dm: support barriers on
> simple devices) barriers are still getting rejected on these simple devices.

> So what's the right way around this?  What should dm (or md for that
> matter) advertise on their queues about ordered-ness?  Should there be
> some sort of "QUEUE_ORDERED_PASSTHROUGH" or something to say "this level
> doesn't care, ask the next level" or somesuch?  Or should it inherit the
> flag from the next level down?  Ideas?

IMO each block device SHOULD provide barriers - either native or emulated,
and each meta device MUST provide emulated barriers if it provides dynamic
device binding and barriers.

