Return-Path: <linux-kernel-owner+w=401wt.eu-S1946023AbXBICXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023AbXBICXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946024AbXBICXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:23:13 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38104 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023AbXBICXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:23:12 -0500
Date: Fri, 9 Feb 2007 03:18:46 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Christopher R. Hertel" <crh@ubiqx.mn.org>
cc: Shirish S Pargaonkar <shirishp@us.ibm.com>,
       Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-cifs-client-bounces+shirishp=us.ibm.com@lists.samba.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: SMB support still missing?
In-Reply-To: <45CBC71F.30607@ubiqx.mn.org>
Message-ID: <Pine.LNX.4.61.0702090317130.8587@yvahk01.tjqt.qr>
References: <OFCB86D528.05DE4D00-ON8725727D.000397BF-8625727D.0003B058@us.ibm.com>
 <45CBC71F.30607@ubiqx.mn.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 18:58, Christopher R. Hertel wrote:
>Shirish S Pargaonkar wrote:
>> 
>> So
>> 1) try tcp  connection on  445,
>>     then if it works send SMB negprot
>> 2) else try tcp connection on port 139
>>     then if it works send nbss request to *SMBSERVER or to the name
>> specified on servernetbiosname
>>     (cifs really should do an ASTAT command and list the valid names and
>> find one if that approach fails but we don't have code for this yet)
>
>This is all correct, and also note that W/9x systems do not support the
>"*SMBSERVER" name.
>
>On the other hand, the name was resolved somehow.  The typical work-arounds
>to not knowning the NBT name of the server are:
>1) Use the name you just resolved (in this case, "CL0").
>2) Send a Node Status Query and look for the first unique <20> name.

I'd just do this:

 (1) try 445/tcp
 (2) try 139/tcp
 (3) try 139/tcp with uppercase hostname (mount //hostname/share) as
     default servernetbiosname



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
