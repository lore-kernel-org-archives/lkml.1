Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbZG0CoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbZG0CoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 22:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZG0CoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 22:44:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:54125 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbZG0CoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 22:44:13 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
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
Date: Sun, 26 Jul 2009 22:43:47 -0400
In-Reply-To: <20090727020611.GC3711@parisc-linux.org> (Matthew Wilcox's
	message of "Sun, 26 Jul 2009 20:06:11 -0600")
Message-ID: <yq18wiakfq4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A6D1465.01D8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

First let's see if I actually interpreted the responses correctly and
that this fixes the issue.

Matthew> and the sd code seems to check for that.  So what bug are you
Matthew> papering over here?

The USB drive in question appears to go tits up when we send it an
extended inquiry.  I contemplated adding a BLIST option but we really
only need EVPD to access pages 0xB0 and 0xB1.  The Block Limits page
appeared in SBC2 so I'm just trying to play it safe.  And hopefully fix
Tarkan's problem in the process.

-- 
Martin K. Petersen	Oracle Linux Engineering
