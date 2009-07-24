Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZGXODK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZGXODK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZGXODJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:03:09 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:45155 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZGXODD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:03:03 -0400
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
Date: Fri, 24 Jul 2009 10:02:37 -0400
In-Reply-To: <4A69932E.90906@turknet.net.tr> (Tarkan Erimer's message of "Fri,
	24 Jul 2009 13:55:42 +0300")
Message-ID: <yq1fxcmnpqa.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A69BF00.01A0:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tarkan" == Tarkan Erimer <tarkan.erimer@turknet.net.tr> writes:

Tarkan> Today, I had time to bisect and you were right: The below commit
Tarkan> related to capacity detection changes in SCSI subsystem,as you
Tarkan> mentioned, seems the cause of the problem.

Thanks for bisecting this.


Tarkan>     Detect non-rotational devices and set the queue flag
Tarkan>     accordingly.

Aha, so you're getting USB resets because your USB-ATA bridge gets
confused when we ask it a simple question.  What a marvel of modern
engineering that thing is...

Please send me the output of:

sg_inq -e /dev/foo
sg_inq -l 16 /dev/foo
sg_inq -l 16 -e /dev/foo
sg_inq -l 36 /dev/foo
sg_inq -l 36 -e /dev/foo
sg_vpd -p sv /dev/foo
sg_vpd -p bl /dev/foo
sg_vpd -p bdc /dev/foo

-- 
Martin K. Petersen	Oracle Linux Engineering
