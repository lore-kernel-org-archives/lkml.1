Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbXLKTGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbXLKTGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXLKTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:05:56 -0500
Received: from mga10.intel.com ([192.55.52.92]:6330 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752322AbXLKTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:05:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,153,1196668800"; 
   d="scan'208";a="432916172"
Message-ID: <475EDFA3.1070001@linux.intel.com>
Date: Tue, 11 Dec 2007 14:06:11 -0500
From: Anas Nashif <nashif@linux.intel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
References: <475EC9C1.9080708@linux.intel.com> <p7363z5nlo8.fsf@bingen.suse.de> <475ED912.609@linux.intel.com> <20071211185317.GA21864@one.firstfloor.org>
In-Reply-To: <20071211185317.GA21864@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> On Tue, Dec 11, 2007 at 01:38:10PM -0500, Anas Nashif wrote:
>> There are different ways you can connect to the Firmware and it all depends on
>> the ME subsystem you want to communicate with.
>> For Intel AMT, you would use LMS (Local Manageability Service) which acts as a
>> proxy for SOAP messages coming for management applications. LMS is available via
>> http://openamt.org/wiki/LocalManageabilityService.
>>
>> The demo we had for storing kernel oops messages in the firmware used the AMT
>> 1.0 interface (legacy) which allowed direct access to 3PDS using the MEI driver
>> interfaces. In AMT 3.0 (current platforms) this has been disabled and only SOAP
>> is possible which is why in the demo we changed the ME firmware to use AMT 1.0.
> 
> Ok but saving oops is such a useful facility that we'll probably need 
> to think about implementing SOAP in the kernel. Before everybody complains
> that I went crazy: I suspect with some simplifying assumptions it could
> be made relatively straight forward code. In particular if one assumes
> no packets get lost then it would be possible to strip down TCP greatly
> (so it doesn't need to be much more complicated than netconsole) 
> and I suspect a very minimal SOAP parser just for this application would
> be also possible.

Actually no TCP/IP is needed here. Basically the MEI driver writes and reads the
messages to/from the firmware. When communicating in-band using LMS, TCP/IP
terminates at LMS and the messages are copied using MEI driver.

> 
>> To have a feel for all of this, with many examples, samples and documentation
>> you can download the AMT 3.0 SDK (google: intel amt sdk).
> 
> I would be more interested right now how the kernel can use this without
> additional user space support. Any ideas on this? 

I will dig for some documents on that.

Anas

> 
> -Andi
> 
