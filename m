Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbZDNSTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbZDNSTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZDNSTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:19:07 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:54534 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbZDNSTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:19:05 -0400
Message-ID: <49E4D2FF.8090906@csr.com>
Date: Tue, 14 Apr 2009 19:16:31 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
References: <49E4BFD0.2020302@csr.com> <20090414165905.GA25645@kroah.com>
In-Reply-To: <20090414165905.GA25645@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: david.vrabel@csr.com
Subject: Re: device_for_each_child() before device_add() doesn't work
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on localhost)
X-Originating-Smarthost02-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Apr 14, 2009 at 05:54:40PM +0100, David Vrabel wrote:
>> Calling device_for_each_child() on a device that has yet to be added
>> (with device_add()) used to work.  UWB subsystem currently tries to do this.
>>
>> Since "driver core: move klist_children into private structure"[1] this
>> no longer works (an oops occurs in device_for_each_chid()).  Is it
>> something that ought to work? Or should the UWB subsystem be changed to
>> not do this?
> 
> Why would you call device_for_each_child() if you have never added it to
> the bus?  How would you expect that to work, as there will never be any
> children for it?

The children of a UWB radio controller (RC) are it's neighbors.  When 
assigning a random DevAddr to an RC we need to check that the address is 
  unique within the beacon group.  We use device_for_each_child() here 
to check that the generated DevAddr is not used by any of its neighbors.

This address must be assigned during initialization and during normal 
operation and in the past we didn't need to special case the address 
assignment during initialization.

David
