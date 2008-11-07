Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYKGBa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYKGBa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYKGBat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:30:49 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21600 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYKGBas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:30:48 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=9lPYMOVCGfFVaQSCIo0A:9 a=aIo9vvC5zFlSIZ9SgumpcnxtsXcA:4 a=-K89oSUuKccA:10 a=zH5cRDhRffsA:10
Message-ID: <49139A43.4000203@shaw.ca>
Date: Thu, 06 Nov 2008 19:30:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Zhao Yakui <yakui.zhao@intel.com>, Len Brown <lenb@kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
References: <fa.UVpnVba3yRAWG3rGZ0sk20JE9hs@ifi.uio.no> <fa.FPBNKx3BSvZHPZ+eXD4Tb+fuRYk@ifi.uio.no> <fa.PvVEuEo+f/t4sLmcGyN2Tsl8zYg@ifi.uio.no> <fa.zzFdOXisTZzBaE1+ueGIYmt+Z5c@ifi.uio.no> <fa.vQ6HVRcPFFr1zpcXFFOjEPtDdNk@ifi.uio.no> <fa.ckUqcrtVKbxAkjNggIdajBTHr9Q@ifi.uio.no>
In-Reply-To: <fa.ckUqcrtVKbxAkjNggIdajBTHr9Q@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Nov 07, 2008 at 09:01:19AM +0800, Zhao Yakui wrote:
> 
>> With the help of KVM I find that the windows will be rebooted by writing
>> RESET_VALUE to RESET_REG I/O port if the RESET_REG_SUP bit is not
>> zero(It indicates whether ACPI reboot is supported).
>> IMO maybe the ACPI reboot is the first choice. If it can't, then it will
>> fall back to other mode.
> 
> Hmm. But we're seeing some machines that end up very confused if 
> rebooted via ACPI. I guess we need to run Vista on them to find out how 
> they behave. What OSI strings did your KVM setup expose? We know that 
> Windows changes behaviour under various circumstances depending on which 
> OS the firmware requests, so it's almost possible that this is another 
> of those cases.

Given that Windows behavior, this patch seems suspicious:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8fd145917fb62368a9b80db59562c20576238f5a

This patch ignores the RESET_REG_SUP flag and just tries using the reset 
register anyway if it thinks it's valid. So we may attempt ACPI reset on 
machines which don't indicate it's supported.

The patch description mentioned that some machines didn't reboot after 
S3 suspend without this patch. However, we recently had this patch merged:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a68823ee5285e65b51ceb96f8b13a5b4f99a6888

Is it possible that the problem fixed there is the true cause of this 
reboot after S3 problem?
