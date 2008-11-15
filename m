Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYKOPrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYKOPrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 10:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYKOPrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 10:47:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:14269 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYKOPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 10:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RHra36+cZn3mAjGe9rsdx2BVjhTzIT0ojwUl99L/h7Guo5pj6Gswn7GM/1uAmpqB1J
         wX+y+IS2Ag3Dd/ji0Kyg4HgdheQtouuIwdB8t837X5+waO9Rynq3pF7Prm2ftgqBQVvt
         VY3T6xLRocOxDOL/Q5zZx++omHGx1h1YJvJu0=
Message-ID: <f9be06770811150747l574badc1l8d509baae4f81ac5@mail.gmail.com>
Date: Sat, 15 Nov 2008 10:47:10 -0500
From: "Karl Pickett" <karl.pickett@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: tcp_tw_recycle broken?
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <874p2916hb.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9be06770811142037v794cf4f8w7a82ab45c0f3820c@mail.gmail.com>
	 <20081115055748.GY24654@1wt.eu>
	 <f9be06770811142329x7d6dcb89vd573962970d503b3@mail.gmail.com>
	 <874p2916hb.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 8:09 AM, Andi Kleen <andi@firstfloor.org> wrote:
> "Karl Pickett" <karl.pickett@gmail.com> writes:
>>
>> May I just confirm.. is tcp_tw_reuse NOT dependent on receiving timestamps?
>
> The big problem is that both are incompatible with NAT. So if you
> ever talk to any NATed clients don't use it.
>
> -Andi
>
> --
> ak@linux.intel.com
>


Hmph.  Running the test again - after getting a little sleep -
timestamps do indeed determine if tw_reuse/recyle work.  I must not
have let all the tw buckets expire before changing my timestamp
settings last night.

Since
A. I don't want to rely on arbitrary web servers having timestamps
B. People say it breaks NAT for clients, and the settings are global only,

I will just set TCP_TIMEWAIT_LEN to 10 seconds and call it a day.
Sure would be nice if it was a tunable, so only the most heavily
loaded customers could set it...

-- 
Karl Pickett
