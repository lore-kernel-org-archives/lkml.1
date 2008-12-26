Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYLZVpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYLZVpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYLZVpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:45:01 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:47459 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYLZVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gmBYvRe57LkJtPdmz3frDbOPNrGe2x92ynNkSQ6RalPCkvaskvmu7vymTNSw3kDyzd
         56Npmo2uGIJhqdZrFNy1J2gjEq/2HkLQEeiG5asOHXO72gncobzGMMXXrUnycMwfjw51
         nEBOx5piPlDO335H8SY5RefMzKKZKT6jZ5YnU=
Message-ID: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Date: Fri, 26 Dec 2008 16:44:57 -0500
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: Redeeman <redeeman@metanurb.dk>
Subject: RFC: detection of silent corruption via ATA long sector reads
Cc: piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Mark Lord" <liml@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

On the mdraid list, there was a recent thread about using raid
functionality to detect / repair silent corruption.

The issues brought up were that a lot of silent data corruption occurs
when cables, controllers, power supplies, ram, cache, etc. goes bad.

It made me think about another option for detecting silent corruption
I have not seen discussed, but maybe I missed it.

Aiui, the ATA spec allows for the reading of a long sector as well as
the normal 512 byte sector.  When you get a long sector you also get
the CRC (or whatever checksum data there is on the disk that allows
the drive itself to detect media errors).

I don't have any idea how easy or hard it would be to do, but I would
like to see the entire block subsystem enhanced to optionally allow
long sector reads to be used in a "paranoid" fashion.

Effectively it would be:

1) Read long sector from drive:  verify CRC in kernel.  This tests
most everything on the i/o path.

2) maintain CRC type information in block subsystem.  Verify no
corruption just before handing off to userspace.  This would
potentially identify CPU/cache/RAM failures.

Mark Lord has implemented long sector reads via hdparm.  Mark can you
comment on the feasibility of this idea?

Thanks
Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
