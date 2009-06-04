Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbZFDSZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbZFDSZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZFDSZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:25:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZFDSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:25:28 -0400
Message-ID: <4A281161.8010109@redhat.com>
Date: Thu, 04 Jun 2009 21:24:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, bhutchings@solarflare.com, andi@firstfloor.org,
       gregkh@suse.de, herber@gondor.apana.org.au, chrisw@sous-sol.org,
       shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 03/19] vbus: add connection-client helper infrastructure
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163057.32740.27829.stgit@dev.haskins.net> <20090604180611.GA16387@redhat.com> <4A280FE2.2090101@novell.com>
In-Reply-To: <4A280FE2.2090101@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

    

>> BTW, why did you decide to use get_user_pages?
>> Would switch_mm + copy_to_user work as well
>> avoiding page walk if all pages are present?
>>   
>>     
>
> Well, basic c_t_u() won't work because its likely not "current" if you
> are updating the ring from some other task, but I think you have already
> figured that out based on the switch_mm suggestion.  The simple truth is
> I was not familiar with switch_mm at the time I wrote this (nor am I
> now).  If this is a superior method that allows you to acquire
> c_t_u(some_other_ctx) like behavior, I see no problem in changing.  I
> will look into this, and thanks for the suggestion!
>   

copy_to_user() is significantly faster than get_user_pages() + kmap() + 
memcmp() (or their variants).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

