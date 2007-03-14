Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXCNQdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXCNQdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXCNQdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:33:46 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17633 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbXCNQdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:33:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Clarification required about select vs wake_up race condition
Date: Wed, 14 Mar 2007 09:33:41 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A419@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <1173870475.3538.4.camel@laptopd505.fenrus.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Clarification required about select vs wake_up race condition
thread-index: AcdmKTxwk05dnXwdQvi/Lhf1UUGD+wALCcCQ
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com> <1173870475.3538.4.camel@laptopd505.fenrus.org>
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Mar 2007 16:33:42.0387 (UTC) FILETIME=[87244430:01C76656]
Authentication-Results: sj-dkim-1; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Our driver is not in the kernel tree yet.
The code snippet from poll entry point is as follows:

    mask = 0;
    poll_wait(filp, &(sap_desc->recv_any_wq), poll_table);
    /* We don't have yet a waiting queue for writers... */
    lock_mts();
    if ((sap_desc->recv_q.first != NULL) &&
        (block_ssync_event(sap_desc->recv_q.first) == FALSE)) {
        /* The queue can be read. */
        mask |= POLLIN | POLLRDNORM;
    }
    unlock_mts();
    //MTS_HOOK(mts_syscall_exit,__FUNCTION__,mask);
    return mask; 

The wake_up_interruptible(&(sap_desc->recv_any_wq)) is executed
from the sending process.

Hope this is sufficient. As I mentioned in my previous mail, what I
am trying to understand better is the kernel code path of do_select() 
versus wake_up_interruptible.

Thanks,
Ravi

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Wednesday, March 14, 2007 4:08 AM
To: Ravinandan Arakali (rarakali)
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clarification required about select vs wake_up race
condition

On Mon, 2007-03-12 at 12:44 -0700, Ravinandan Arakali (rarakali) wrote:
> Hi,
> I am facing following problem and was wondering if somebody could help

> me out.
> Our char driver(pretty much like all other char drivers) does a
> poll_wait()


you forgot to include your (full) sourcecode or a pointer to that...
