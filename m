Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZJBSaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZJBSaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbZJBSap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:30:45 -0400
Received: from claw.goop.org ([74.207.240.146]:57436 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032AbZJBSao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:30:44 -0400
Message-ID: <4AC646D7.5030709@goop.org>
Date: Fri, 02 Oct 2009 11:30:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Kevin Bowling <kevinb@analograils.com>,
       Andrew Jones <drjones@redhat.com>
Subject: Re: INFO: task journal:337 blocked for more than 120 seconds
References: <1254345112.8837.9.camel@localhost.localdomain>
In-Reply-To: <1254345112.8837.9.camel@localhost.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/09 14:11, Shirley Ma wrote:
> Anybody found this problem before? I kept hitting this issue for 2.6.31
> guest kernel even with a simple network test.
>
> INFO: task kjournal:337 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_sec" disables this message.
>
> kjournald	D 00000041	0	337	2 0x00000000
>
> My test is totally being blocked.

I'm assuming from the lists you've posted to that this is under KVM? 
What disk drivers are you using (virtio or emulated)?

Can you get a full stack backtrace of kjournald?

Kevin Bowling submitted a RH bug against Xen with apparently the same
symptoms (https://bugzilla.redhat.com/show_bug.cgi?id=526627).  I'm
wondering if there's a core kernel bug here, which is perhaps more
easily triggered by the changed timing in a virtual machine.

Thanks,
    J
