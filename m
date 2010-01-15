Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab0AOVNz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487Ab0AOVNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:13:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:44932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab0AOVNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:13:53 -0500
Message-ID: <4B50DA47.80800@kernel.org>
Date: Fri, 15 Jan 2010 13:12:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 08/14] pci: update bridge res to get more big range in
 pci assign unssign
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>	<1261522954-12591-9-git-send-email-yinghai@kernel.org> <20100115111254.1f9d66a3@jbarnes-piketon>
In-Reply-To: <20100115111254.1f9d66a3@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 11:12 AM, Jesse Barnes wrote:
> On Tue, 22 Dec 2009 15:02:28 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> BIOS separate IO range between several IOHs, and on some slots, BIOS
>> assign the resource to the bridge, but stop assigning resource to the
>> device under that bridge, because the device need big resource.
>>
>> 1. pci assign unassign and record the failed device resource.
>> 2. clear the BIOS assigned resource of the parent bridge of fail
>> device 3. go back and call pci assign unsigned
>> 4. if it still fail, will go up more bridges. and clear and try again.
>>
>> use pci_try_num to control back track bridge levels.
>>
>> -v2: update it with resource_list_x
>> -v3: make pci_try_num default to 1. and when pci_try_num is set to
>> more than 1 will check it with max_depth, and adjust that to make
>> sure it is bigger enough
> 
> I really don't like the 'try' argument.  Either we can assign the
> resource or not; 'try=' just makes the whole thing scarier, as if we
> expect problems if we release too many resources.  If that's the case,
> then the whole approach must be flawed, since it means we're not taking
> into account some resources, or we're missing something about the
> system configuration.

before this patchset, acctually try = 1, and will not touch pci bridge resource if that are assigned by BIOS.

with this patchset, try = 1, will just like the old ways.
try = 2, it will find the deepest bridge, and increase the try.

YH
