Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXHOLVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXHOLVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbXHOLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:20:58 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:54523 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXHOLU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:20:57 -0400
Message-ID: <46C2E189.7040504@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2007 16:50:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Documentation: fix getdelays.c example -l option and
 segv
References: <18240.1186734285@neuling.org> <46C2A505.7040008@linux.vnet.ibm.com> <11201.1187165591@neuling.org>
In-Reply-To: <11201.1187165591@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

>> Is this really required? a sleep() in the code. Why do we do multiple
>> send_cmd()'s in the do loop? I'll test and get back.
> 
> I needed to send another command to receive more data.  Without the per
> loop send_cmd, I never got any more stats. 
> 
> Should we receive more data without the additional send_cmd?  I've been
> running with: 
>   ./getdelays -d -p 1 -l
> 

Interesting, we never used -l that way. We used -l to get data for all
exiting tasks

./getdelays -d -l

For the usage you've mentioned, I'd use

while :
do
	sleep 2
	./getdelays -p 1 -d
done

I guess your changes change getdelays and since there are other ways
to obtaining the same data, I'd remove the last bit of changes made
to send the TGID often to get data.

> Mikey
> 
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
