Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYIIW0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYIIW0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYIIW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:26:22 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:58587 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYIIW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:26:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48C6F80E.8010509@citrix.com>
Date: Tue, 09 Sep 2008 23:26:22 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Xen: Fix pte unpin BUG when !CONFIG_SMP
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org>
In-Reply-To: <48C6DE6E.1070804@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Alex Nixon wrote:
>   
>>
>> Here's the backtrace of the BUG() the patch addresses.  Now you've
>> pointed it out - I see the asymmetry - and also suspect some ptes are
>> being left pinned.
>>
>> I'm having trouble finding a cleaner solution which solves this but
>> doesn't incite more BUGs.
>> Perhaps you have an idea?
>>     
>
> Right, I see.  We shouldn't be pinning ptes on attachment in
> xen_alloc_ptpage() if we're not using split pte locks.
>
>     J
>
>   
Hmm ok.  I'll search further for a solution which fixes things more 
officially (and deals with the CONFIG_SMP && (NR_CPUS < 
CONFIG_SPLIT_PTLOCK_CPUS) case, which I just realized is also broken, 
and isn't fixed by this patch).

In the meantime, at least UP is now usable.

- Alex
