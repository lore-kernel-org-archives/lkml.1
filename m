Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYGPJRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYGPJRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGPJQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:16:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:4804 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYGPJQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:16:50 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Wed, 16 Jul 2008 11:15:55 +0200
User-Agent: KMail/1.9.9
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
References: <487B05CE.1050508@jp.fujitsu.com> <487C0A76.8060401@qualcomm.com> <200807151810.00365.rusty@rustcorp.com.au>
In-Reply-To: <200807151810.00365.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161115.55214.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. Juli 2008 schrieb Rusty Russell:
> > btw Rusty, I just had this "why didn't I think of that" moments. This is
> > actually another way of handling my workload. I mean it certainly does not
> > fix the root case of the problems and we still need other things that we
> > talked about (non-blocking module delete, lock-free module insertion, etc)
> > but at least in the mean time it avoids wedging the machines for good.
> > btw I'd like that timeout in milliseconds. I think 5 seconds is way tooooo
> > long :).
> 
> We can make it ms, sure.  200ms should be plenty of time: worst I ever saw 
was 
> 150ms, and that was some weird Power box doing crazy stuff.  I wouldn't be 
> surprised if you'd never see 1ms on your hardware.

I disagree that 5 seconds is to long :-). I even think having it default to 0 
is the safest option for virtualized environments. What if the host is paging 
like hell and the vcpu cannot run due to a missing page? In that case 200ms 
can be an incredible short amount of time. If the timeout triggers, 
stop_machine_run fails, but everything would work fine - it just takes 
longer.

