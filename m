Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYCYNz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYCYNz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYCYNzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:55:48 -0400
Received: from picture.zai.com ([12.47.112.36]:31329 "EHLO york.rivers.zai.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754106AbYCYNzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:55:48 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
Subject: RE: Performance changes between 2.6.13 and 2.6.23
Date: Tue, 25 Mar 2008 09:52:36 -0400
Message-ID: <D108F32273D3044F8C7B24328CB7713701A4D2@york.rivers.zai.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Performance changes between 2.6.13 and 2.6.23
Thread-Index: AciOf0zHRl57HJbmQ3SjmBLGSvnY1QAAC6a5
References: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com> <e2e108260803250625k581909dcw3c3c0742a7b9fceb@mail.gmail.com>
From: "Sanders, Rob M." <sanders-rob@zai.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart,
  Each process is single threaded, although each process is built with the 
-lpthread library.  For this particular application I would expect the 
bottleneck to be in I/O (between processes) bound.  I hadn't thought 
about trying to boot YDL4 using the new kernel, I'll try that, and I'll
look at the lmench2 and interbench.  Thanks....

Rob



-----Original Message-----
From: Bart Van Assche [mailto:bart.vanassche@gmail.com]
Sent: Tue 3/25/2008 9:25 AM
To: Sanders, Rob M.
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance changes between 2.6.13 and 2.6.23
 
On Tue, Mar 25, 2008 at 1:34 PM, Sanders, Rob M. <sanders-rob@zai.com> wrote:
>  Of more particular concern, the main application that I build has seen a 4-5X
> slowdown in performance.

Is this a singlethreaded or a multithreaded application ? Is this
application CPU-bound or IO-bound ? Does it rely a lot on memory
allocation ?

I'm not sure this will tell you the cause, but what might help is to
compile and run lmbench2 and interbench, and to compare the results
for the two kernel versions. Make sure that only the kernel version
differs between the two test runs, and that all other components (a.o.
libc and libpthread) stay the same. Booting the old YDL with the new
kernel should work, while booting the new YDL with an old kernel
probably will cause trouble.

See also http://www.bitmover.com/lmbench/ and
http://members.optusnet.com.au/ckolivas/interbench/.

Bart.

