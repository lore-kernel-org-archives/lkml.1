Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXJIPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXJIPao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbXJIPaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:30:23 -0400
Received: from emulex.emulex.com ([138.239.112.1]:55781 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXJIPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:30:21 -0400
Message-ID: <470B9E50.2090205@emulex.com>
Date: Tue, 09 Oct 2007 11:29:20 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
CC: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexis Bruemmer <alexisb@us.ibm.com>,
       James Bottomley <james.bottomley@steeleye.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
 if the adapter lacks one
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org> <20071008235009.GB16003@tree.beaverton.ibm.com> <20071009001240.GA13922@plap3.qlogic.org>
In-Reply-To: <20071009001240.GA13922@plap3.qlogic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2007 15:29:20.0835 (UTC) FILETIME=[29CFF130:01C80A89]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why do you prefer request_firmware() vs something over sysfs ?

Does environments like the kdump kernel also have access to data needed
by request_firmware() ?

-- james s


Andrew Vasquez wrote:
> On Mon, 08 Oct 2007, Darrick J. Wong wrote:
> 
>> On Mon, Oct 08, 2007 at 03:48:32PM -0700, Andrew Vasquez wrote:
>>
>>> So how about factoring that out to a transport-level interface.  How
>>> about something along the lines of the following patch, whereby the
>>> software driver upon detecting no valid WWPN, makes an upcall to each
>>> interface's 'request_wwn()'.  The data passed in from shost_gendev
>>> should be enough for some helper script to cull relevent device bits
>>> and perhaps offer some level of persistence...  Off base?
>> Hrm... jejb made a remark that it might be better to pass the
>> scsi_host's device into request_firmware() as your example does, so I'll
>> pitch in a patch to do likewise with libsas--the scsi_host knows the
>> actual device it's coming from, and userland can sort that all out later
>> anyway via DEVPATH.
>>
>> I suppose one could also have multiple scsi_hosts per PCI device, which
>> means that my first patch would stumble horribly in more than a few
>> cases.
> 
> This is done already in the FC case -- NPIV.  Though with that
> interface, the administrator is already responsible for assigning
> proper WWNN/WWPN during creation.
> 
>>> Darrick, forgive the FC example, I don't do SAS...
>> That's ok, I don't do FC. :)  Looks mostly good to me...
> 
> --
> av
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
