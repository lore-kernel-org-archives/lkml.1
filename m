Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYGDPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYGDPgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYGDPgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:36:04 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:39877 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYGDPgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TWL6u0O+XqnQfY+MvBeUw7zDhRJi+uZPGg1UKm0175OSnsdta1xrIKFQtWwbWWX1Vm
         lr9g4fkLTgaeebclPf4icUY5EJDYhirrjkGwJ2zQnQPnoB07rP3q55wBkIF4ywhQb7HH
         vhoookFVjSmlPV7rc443Agk0gD84ZnmYDnEOk=
Message-ID: <486E435E.3020503@gmail.com>
Date: Fri, 04 Jul 2008 17:35:58 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: ptb@inv.it.uc3m.es
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
References: <200806201611.m5KGBDN02249@inv.it.uc3m.es>
In-Reply-To: <200806201611.m5KGBDN02249@inv.it.uc3m.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter T. Breuer wrote:
>> +               Block device I/O bandwidth controller
> 
> How can this work?  You will limit the number of available buffer heads 
> per second?
> 
> Unfortunaely, the problem is the fs above the block device.  If the
> block device is artificially slowed then the fs will still happily allow
> a process to fill buffers forever until memory is full, while the block
> device continues to trickle the buffers away.
> 
> What one wants is for the fs buffering to be linked to the underlying
> block device i/o speed. One wants the rate at which fs buffers are
> filled to be no more than (modulu brief spurts) the rate  at which the
> device operates.
> 
> That way networked block devices have a chance of having some memory
> left to send the dirty buffers out to the net with. B/w limiting the
> device itself doesn't seem to me to do any good.
> 
> Peter

Peter,

I see your message only now, it seems you didn't add me in to or cc.

Anyway, I totally agree with you, but it seems there's a
misunderstanding here. The block device i/o bw controller *does*
throttling slowing down applications' requests and not the dispatching
of the already submitted i/o requests.

IMHO, for the same reason you pointed, delaying the dispatching of i/o
requests simply leads to an excessive page cache and buffers
consumption, because userspace apps dirty ratio is actually never
limited.

As reported in the io-throttle documentation:

"This controller allows to limit the I/O bandwidth of specific block
devices for specific process containers (cgroups) imposing additional
delays on I/O requests for those processes that exceed the limits
defined in the control group filesystem."

Do you think we can use a better wording to describe this concept?

-Andrea
