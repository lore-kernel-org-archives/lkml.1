Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbZCRV57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbZCRV57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZCRVvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:51:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41932 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760257AbZCRVvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:51:21 -0400
Message-ID: <49C16CD4.3010708@us.ibm.com>
Date: Wed, 18 Mar 2009 14:51:16 -0700
From: Vernon Mauery <vernux@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eilon Greenstein <eilong@broadcom.com>
CC: Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
References: <49C12E64.1000301@us.ibm.com> <87prge1rhu.fsf@basil.nowhere.org> <49C16294.8050101@us.ibm.com> <1237412732.29116.2.camel@lb-tlvb-eliezer>
In-Reply-To: <1237412732.29116.2.camel@lb-tlvb-eliezer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eilon Greenstein wrote:
> On Wed, 2009-03-18 at 14:07 -0700, Vernon Mauery wrote:
>>> The real "fix" would be probably to use a multi queue capable NIC
>>> and a NIC driver that sets up multiple queues for TX (normally they
>>> only do for RX). Then cores or a set of cores (often the number
>>> of cores is larger than the number of NIC queues) could avoid this
>>> problem. Disadvantage: more memory use.
>> Hmmm.  So do either the netxen_nic or bnx2x drivers support multiple
>> queues?  (that is the HW that I have access to right now).  And do I
>> need to do anything to set them up?
>>
> The version of bnx2x in net-next support multi Tx queues (and Rx). It
> will open an equal number of Tx and Rx queues up to 16 or the number of
> cores in the system. You can validate that all queues are transmitting
> with "ethtool -S" which has per queue statistics in that version.

Thanks.  I will test to see how this affects this lock contention the
next time the broadcom hardware is available.

--Vernon
