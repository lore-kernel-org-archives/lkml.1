Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZG0PUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZG0PUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZG0PUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:20:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28467 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZG0PUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:20:06 -0400
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
	<yq1hbwykj80.fsf@sermon.lab.mkp.net>
	<20090727020611.GC3711@parisc-linux.org>
	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com>
	<yq1ocr66vy6.fsf@sermon.lab.mkp.net> <4A6DBEEB.5020302@panasas.com>
Date: Mon, 27 Jul 2009 11:19:39 -0400
In-Reply-To: <4A6DBEEB.5020302@panasas.com> (Boaz Harrosh's message of "Mon,
	27 Jul 2009 17:51:23 +0300")
Message-ID: <yq1fxci6tmc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A6DC58E.010F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> Haa, OK. I thought INQUIRY EVPD=1 page=0 was so old it sure must
Boaz> be supported but you are saying it's only SBC2/SPC3. So I guess
Boaz> there is nothing else we can do.

Yes, EVPD must be supported.  USB-ATA bridge firmware writers are
dyslexic.  Film at 11.

What I'm saying is that *our* reason for sending out extended inquiry
appeared in SBC2 (block limits VPD).  So there is no point in asking
devices older than that.

The fact that this fixes the problem for Tarkan's crappy disk is a
(quasi-intentional) side effect.  My patch simply tries to be
conservative about asking for those pages.


Boaz> What I hate about all this is that in USB the scsi_level is hard
Boaz> coded at the driver, without actually been able to probe the
Boaz> device about it.

Huh, what?

-- 
Martin K. Petersen	Oracle Linux Engineering
