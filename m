Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYIPUrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYIPUrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYIPUrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:47:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21187 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYIPUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:x-mailer;
        b=cziOu1YHW3xHR7bWihJ3iFHZ5y7A+hYmrtTKCkCq13y3JAk26Q0AP2V7ubnTYZff8q
         H7dwTotdxb8PXxep8zDHB5zPX6wbgAOylswcHujc2KEAiWKfOcBPOAL5rAXhcXOks+2e
         T9GfMw9hGeJ4MjEP/fb1dxaSn6em3cvzcGrNc=
Message-Id: <C8EF81DF-B01A-45B4-BBC5-7979A032381D@gmail.com>
From: Chase Douglas <chasedouglas.lists@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Signal debugging/tracing
Date: Tue, 16 Sep 2008 16:47:34 -0400
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm debugging a uClibc pthreads issue that occurs during a stress test  
where many threads are looping many times forking off child processes  
that exec() other executables. Child processes are writing to a pipe  
that the parent threads are reading. After some iterations in the  
loops, the threads that are reading from the pipe using read() are  
getting EINTR. If you put the read in a loop so that an EINTR is  
ignored and you just try again, each subsequent read call returns  
immediately with EINTR again.

I'm assuming right now that the EINTR is due to a stray signal  
occurring somewhere, probably due to pthreads. Unfortunately, my  
debugging isn't showing that the process is signaling any other  
process or itself in a way that would cause an EINTR. All I see are  
SIGRTMIN signals getting raised. If it truly is an issue of signals  
being raised, what techniques can be used to determine what signals  
are being sent to the process and from where are the signals coming  
from?

Thanks,
Chase Douglas
