Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZFVJy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZFVJy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZFVJyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:54:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43174 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZFVJyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:54:17 -0400
Message-ID: <4A3F54F9.9060506@redhat.com>
Date: Mon, 22 Jun 2009 12:55:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v3] KVM support for 1GB pages
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <4A3CC1FA.2070900@redhat.com> <20090622094013.GD5139@amd.com> <4A3F524C.8030902@redhat.com> <20090622094953.GE5139@amd.com>
In-Reply-To: <20090622094953.GE5139@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 12:49 PM, Joerg Roedel wrote:
>>> After the rework it even fails to boot a guest with gbpages enabled. This week
>>> is a bit tight but I will debug this further next week.
>>>
>>>        
>> Does the failure happen only when both guest/host use gbpages, or does
>> it also happen if gbpages is disabled on either one?
>>      
>
> It happens only when the guest uses gbpages. If I disable them at boot the
> linux guest boots fine and runs stable.
>    

This seems to point the finger at the write protection logic, either we 
create a gbpage even though there are shadowed page tables in its area, 
or (more likely) we don't break up a gbpage when we write protect a page.

-- 
error compiling committee.c: too many arguments to function

