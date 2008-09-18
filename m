Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYIRFeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYIRFeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 01:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYIRFeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 01:34:14 -0400
Received: from main.gmane.org ([80.91.229.2]:37391 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYIRFeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 01:34:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.s@india.com>
Subject: Re: execve errno setting on MIPS
Date: Thu, 18 Sep 2008 05:34:00 +0000 (UTC)
Message-ID: <loom.20080918T052854-761@post.gmane.org>
References: <loom.20080918T041321-307@post.gmane.org> <48D1DF43.4090804@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 121.100.32.51 (Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I will change the Subject line "execve exit status on MIPS" first.


David Newall <davidn <at> davidnewall.com> writes:
> 
> Halesh S wrote:
> > char e2BIG[ARG_MAX+1][10];
> > ...
> >   for(ind = 0; ind < ARG_MAX+1; ind++)
> >     strcpy(e2BIG[ind], "helloworld");
> >   
> 
> Did you intend to overflow e2BIG?  You're copying 11 bytes (including
> terminating NUL) into a 10 byte array.
> 

My intenstion is not to overflow in string...
We can change
> >     strcpy(e2BIG[ind], "helloworld");
to
     strcpy(e2BIG[ind], "helloworl");

But intenstion is to generate E2BIG in
  if ((ret = execve(EXE_NAME,e2BIG,envList)) == -1) {

where e2BIG array has more number arguments than ARG_MAX.

Which was possible on ARM,PPC and i386....

For the same code...I got 14 EFAULT....


Thanks,
Halesh








