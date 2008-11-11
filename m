Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYKKOsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYKKOsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbYKKOr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:47:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:52389 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbYKKOr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KJ44QRqZwfFU5ZtR4AswaygT4658PZDdV/H5WlVHZtiks/mNMJPxBQgfef409fUahG
         DD4hOfibvFwaawACqpIyof6Y2ss57WDIYymP5DMkFVdVM3itjsRcxZi4z6bRzdvASuc0
         QICoR87no7rJxBBE2Tvl86XcGX2jgcXuzC77o=
Message-ID: <19f34abd0811110647y2a00cfbfr2b219a5aa1b3ac9f@mail.gmail.com>
Date: Tue, 11 Nov 2008 15:47:56 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081111105214.GA15645@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <20081110120401.GA15518@osiris.boeblingen.de.ibm.com>
	 <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl>
	 <20081111105214.GA15645@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 11:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
> [ Cc:-ed workqueue/locking/suspend-race-condition experts. ]
>
> Seems like the new kernel/stop_machine.c logic has a race for the test
> sequence above. (Below is the bisected commit again, maybe the race is
> visible via email review as well.)

I try again.

I think that the test for stop_machine_data in stop_cpu() should not
have been moved from __stop_machine(). Because now cpu_online_map may
change in-between calls to stop_cpu() (if the callback tries to
online/offline CPUs), and the end result may be different.

Maybe?


Vegard
