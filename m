Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbYEGUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbYEGUs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYEGUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:48:14 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:43304 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYEGUsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:48:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Patches for piping to core pattern ?
Date: Wed, 7 May 2008 13:48:09 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA11C@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA10C@xmb-sjc-214.amer.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Patches for piping to core pattern ?
Thread-Index: AciuyMQXyBD1ccF5SGaLdEeQiRytmgAUPtdQAFpQ8lA=
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA104@xmb-sjc-214.amer.cisco.com> <20080505085609.32482c03.randy.dunlap@oracle.com> <FA6FB5FA4DA6BF4386D129273B2E3EC3034CA10C@xmb-sjc-214.amer.cisco.com>
From: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 20:48:09.0977 (UTC) FILETIME=[A8D49E90:01C8B083]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon adding some debugs, I find that it dumps core file upto
4096 bytes and after that, when pipe_write() notices that the 
free memory is less than the requested size, it checks for 
pending signals and exits from pipe_write().

But note that the user-level application on the read end of
the pipe does get to process the 4096 bytes since I get
a compressed core file. Problem is that the writer bails out
after 4K.

Any ideas ?

Thanks,
Ravi

 

-----Original Message-----
From: Ravinandan Arakali (rarakali) 
Sent: Monday, May 05, 2008 6:55 PM
To: 'Randy Dunlap'
Cc: Linux Kernel
Subject: RE: Patches for piping to core pattern ?

Randy,
Thanks for the pointers to the patches. 
I am now able to see the core getting streamed to a program (such as
gzip). 

But I see that the core itself is quite small (truncated). 
I see this behavior even when using the normal core_pattern (without the
"|" ). Wonder if it has something to do with the changes to binfmt_elf.c
? I'm not sure why these changes are required for pipe support.

Thanks,
Ravi
 

-----Original Message-----
From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
Sent: Monday, May 05, 2008 8:56 AM
To: Ravinandan Arakali (rarakali)
Cc: Linux Kernel
Subject: Re: Patches for piping to core pattern ?

On Sun, 4 May 2008 19:24:59 -0700 Ravinandan Arakali (rarakali) wrote:

> Hi,
> I am trying to port the "piping cores to an executable" to our kernel 
> (2.6.10 based). I took Andi Kleen's patch (3/3) available at 
> http://lwn.net/Articles/195310/ and some of the supporting functions 
> from 2.6.19. But it's not working for me.
> 
> Andi's patch mentions "Using the infrastructure created in previous 
> patches implement support to pipe core dumps into programs."
> 
> Can somebody point me to these previous patches ?

I don't know if these patches 1/3 and 2/3 represent the complete
infrastructure that Andi referred to, but you can find them here:

http://www.uwsg.indiana.edu/hypermail/linux/kernel/0608.1/2339.html
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0608.1/2340.html


---
~Randy
