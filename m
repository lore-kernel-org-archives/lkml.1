Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbXGZCif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbXGZCif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 22:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbXGZCi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 22:38:28 -0400
Received: from [202.78.101.198] ([202.78.101.198]:48780 "EHLO mx1.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755957AbXGZCi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 22:38:27 -0400
Message-ID: <46A80937.1040608@gmail.com>
Date: Thu, 26 Jul 2007 10:38:48 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about core file generation
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B80E8@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B80E8@xmb-sjc-214.amer.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravinandan Arakali (rarakali) wrote:
> Hi,
> When a process dumps core, the do_coredump() initiates the core
> file generation. Is this operation synchronous(does the kernel
> wait for core to be completely written to disk) ?

The operations whereby

(1) a process is in the process of exiting while;
(2) the kernel is doing a coredump

is asynchronous with respect to each other, since the process could have 
received an abort signal while the the kernel initiated the core dump.

> Basically, if I have the parent process waiting for exit of
> child which dumped core, can the parent access the core immediately
> on receipt of "child exit" message ? Is it possible that the
> core is still in the process of being written ? If so, what's
> the event the parent needs to wait for to be assured of a complete
> core.

When a child exits, check if the core dump file is still opened by a handle 
(HINT: lsof).

AFAICS from the kernel code, the core dump data or file routine is mutexed 
to ensure that there is only one process handling the core dump file.

You could check if there are still open file handles on the dump.  If there 
are none, it means that the dump had been completed.

HTH.

Best Regards,

Carlo

-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, Diliman 1101, Quezon City
Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
