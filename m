Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbZF2J4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbZF2J4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZF2Jzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:55:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbZF2Jzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:55:48 -0400
Message-ID: <4A489002.1080106@redhat.com>
Date: Mon, 29 Jun 2009 12:57:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCHv2] kvm: remove in_range and switch to rwsem for iobus
References: <20090628193425.GA14204@redhat.com> <4A487D2C.2020007@redhat.com> <20090629092309.GA19167@redhat.com> <4A488D15.4060500@redhat.com> <20090629095132.GD19167@redhat.com>
In-Reply-To: <20090629095132.GD19167@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 12:51 PM, Michael S. Tsirkin wrote:
>> We can convert it to rcu indepenently of other things protected by
>> slots_lock; no need to do everything at the same time.
>>      
>
> Yes but once we merge locks, it will be harder to split them out.
> I know I can now do grep bus_lock and find all places affected,
> if I reuse slot_lock this information is lost. No?
>    

That's true, but for seeing the overall picture, fewer locks are 
better.  I'm more concerned about those looking at all the code (me) 
than those implementing locking improvements (you).

-- 
error compiling committee.c: too many arguments to function

