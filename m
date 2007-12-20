Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbXLTURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbXLTURo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXLTURd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:17:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXLTURb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:17:31 -0500
Message-ID: <476ACDD2.6050809@redhat.com>
Date: Thu, 20 Dec 2007 15:17:22 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matthew Wilcox <matthew@wil.cx>, Loic Prylli <loic@myri.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org> <20071220195021.GA427@jurassic.park.msu.ru>
In-Reply-To: <20071220195021.GA427@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Thu, Dec 20, 2007 at 12:08:33PM -0700, Matthew Wilcox wrote:
>> On Thu, Dec 20, 2007 at 02:04:31PM -0500, Tony Camuso wrote:
>>> Does anybody see a down side to this?
>> It'll be slower than it would be if we used mmconfig directly.  Now yes,
>> nobody should be using pci config space in performance critical paths
>> ... but see the tg3 driver.
> 
> Use type 1 just for the first 64 bytes and tg3 will be happy. All we need
> is to avoid touching BARs with mmconfig.
> 
> Ivan.

Sounds good to me.

However, this does add another in-line test for every pci config access.

The existing test is a lookup in the unreachable_devices bitmap. Even though
the bitmap only covers the first 16 buses, the lookup is performed for every
pci config access.

We would be adding another test,

   if the offset is less than 64 bytes, use legacy pci config
   else use mmconfig

The emitted code would probably only produce one branch, so it shouldn't
present a performance degradation.

Any objections to taking this tact?
