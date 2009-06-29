Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZF2O1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZF2O1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZF2O1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:27:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZF2O1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:27:08 -0400
Message-ID: <4A48CF99.40002@redhat.com>
Date: Mon, 29 Jun 2009 17:28:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       markmc@redhat.com
Subject: Re: [PATCHv2] kvm: remove in_range and switch to rwsem for iobus
References: <20090628193425.GA14204@redhat.com> <20090629140632.GC14059@amt.cnet>
In-Reply-To: <20090629140632.GC14059@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 05:06 PM, Marcelo Tosatti wrote:
> On Sun, Jun 28, 2009 at 10:34:25PM +0300, Michael S. Tsirkin wrote:
>    
>> This changes bus accesses to use high-level kvm_io_bus_read/kvm_io_bus_write
>> functions, which utilize read/write semaphore intead of mutex.  in_range now
>> becomes unused so it is removed from device ops in favor of read/write
>> callbacks performing range checks internally.
>>
>> This allows aliasing (mostly for in-kernel virtio), as well as better error
>> handling by making it possible to pass errors up to userspace. And it's enough
>> to look at the diffstat to see that it's a better API anyway.
>>      
>
> Can you please expand a little on this? Still don't get why making
> ->in_range part of ->read / ->write is a good thing. Aliasing?
>    

Yes, if you have several devices responding to the same port (but 
different values), in_range() by itself doesn't tell you much.  virtio 
msi support will tie a different iosignalfd to every queue, and queues 
are notified by writing different values to one pio port.

-- 
error compiling committee.c: too many arguments to function

