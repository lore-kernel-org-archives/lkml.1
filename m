Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZBZFRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZBZFRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZBZFRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:17:08 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:29007 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZBZFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:17:06 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: Theodore Tso <tytso@mit.edu>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<20090226025043.GJ1363@mit.edu>
	<20090226030735.GA16891@parisc-linux.org>
Date: Thu, 26 Feb 2009 00:16:00 -0500
In-Reply-To: <20090226030735.GA16891@parisc-linux.org> (Matthew Wilcox's message of "Wed\, 25 Feb 2009 20\:07\:35 -0700")
Message-ID: <yq1eixlg4mn.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49A62594.015B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> Lowest aligned logical block address=0

Matthew> This disagrees with Martin's assertion.

Quick answer from one of my contacts.  Desktop drives will indeed ship
with an alignment of 1(*).  The alignment is hardwired at time of
manufacture and can't be changed.

(*) I had to go back and reread the ATA spec to grok this.  READ
CAPACITY(16) indicates the lowest naturally aligned LBA.  With LBA 63
offset in play that would be LBA 7.

ATA, on the other hand, indicates how much LBA 0 is offset from the
beginning of the first physical sector.  If LBA 63 is naturally aligned
that means that LBA 0 is offset 512 bytes (physical sector 0 starts at
LBA -1 if you will). Hence IDENTIFY DEVICE word 209 will contain 0x4001.

So you need to tweak your RC16 response a bit...

-- 
Martin K. Petersen	Oracle Linux Engineering
