Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZBMSV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZBMSV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZBMSVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:21:46 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:23892 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZBMSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:21:45 -0500
Message-ID: <4995BA4B.9050209@oracle.com>
Date: Fri, 13 Feb 2009 10:22:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Sachin P. Sant" <sachinp@in.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: next Feb 13 drivers/scsi/aha1542.ko build break
References: <20090213175526.d0590862.sfr@canb.auug.org.au> <49955D00.2020707@in.ibm.com>
In-Reply-To: <49955D00.2020707@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4995BA2B.002F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin P. Sant wrote:
> Feb 13 next x86 allmodconfig build breaks with
> 
> ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!
> 
> .config attached.


I'm seeing that also.  I think that it's this line in aha1542.c:

495:		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);

since I can comment out the "/ sizeof(struct ccb)" and the driver builds successfully.

This may need a patch to use one of the div() macros (?).


-- 
~Randy
