Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbZJNVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbZJNVvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZJNVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:51:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50025
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbZJNVvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:51:43 -0400
Date: Wed, 14 Oct 2009 14:51:39 -0700 (PDT)
Message-Id: <20091014.145139.148344015.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: oleg@redhat.com, torvalds@linux-foundation.org, paulkf@microgate.com,
       btanastasov@yahoo.co.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, dmitry.torokhov@gmail.com, edt@aei.ca,
       hirofumi@mail.parknet.co.jp
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091014221633.1b865651@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain>
	<20091014195215.GA12936@redhat.com>
	<20091014221633.1b865651@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 14 Oct 2009 22:16:33 +0100

>> Assuming that we should not check all CPUs. And in this case perhaps we can
>> even do something like
>> 
>> 	if (!delayed_work_pending() &&
>> 	    get_wq_data()->current_work != dwork)
>> 		return;
>> 
>> but this needs barriers, and run_workqueue() needs mb__before_clear_bit().
> 
> Linus correctly said that we got into the mess because the locking was
> too clever before. At this point the mutex approach seems to be rather
> preferable to the other approaches which are at least as "clever" as the
> current locking

FWIW I've been seeing behavior that is almost certainly caused by this
bug for a while, I lose 'control' or 'shift' key-down events and this
is entirely independent of keyboard attached (i've tried several) and
seems to only happen on an SMP box.

It's most accutely annoying if it triggers while playing quake3 :-)
