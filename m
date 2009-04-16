Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZDPXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZDPXaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZDPXam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:30:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57774 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZDPXam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:30:42 -0400
Message-ID: <49E7BF34.6060002@zytor.com>
Date: Thu, 16 Apr 2009 16:28:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Oruba <peter.oruba@amd.com>, amd64-microcode@amd64.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode driver newly spews warnings
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org> <20090413182746.GA9954@elte.hu> <49E5EABB.9010402@garzik.org> <b647ffbd0904150751u64e69097q79c511533f949c00@mail.gmail.com> <20090416230731.GA19553@elte.hu> <49E7BD64.7060507@garzik.org>
In-Reply-To: <49E7BD64.7060507@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>> Jeff, did this do the trick for you?
> 
> Yes -- but I worry about keeping sysfs files around too long?
> 
>     Jeff

OK, what isn't clear to me is what the proper return value is in this 
case.  In particular, how with the caller react to mc_sysdev_add() 
returning a nonzero value, but still have the sysdev devices created and 
retained?

What I would expect happen would be that sysdev_register_driver() would 
return an error and we would unregister the notifier, which really isn't 
the right thing -- if the intent is to keep the sysdev devices around 
for a possible later update then we should presumably return zero there, 
i.e. ignore the return value from microcode_init_cpu(); completely?

	-hpa

