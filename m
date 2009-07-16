Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZGPHcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZGPHcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZGPHcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:32:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZGPHct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qDXpoMGVdoQkJ9LzpeTCV+3hdHY92aBcNP/G6gw+MiheM+5cBa2q952xcZ3PhcIiYp
         r5oBK8utcTkCI1IP07n486P4micnb2LEEkBsKrc4nYGBf/LutiXpnmArzYuXOfTbcgiI
         LMGGUl24pFjrmAlnhdC5WzhCZryRmdXr7k9GE=
MIME-Version: 1.0
In-Reply-To: <4A5D7794.2070607@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A5395FD.2040507@vlnb.net>
	 <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com>
	 <4A5493A8.2000806@vlnb.net>
	 <a0272b440907092332o7c5bf1d0oa51d1cfc9b9e98f5@mail.gmail.com>
	 <4A56FF32.2060303@vlnb.net> <4A570981.5080803@vlnb.net>
	 <a0272b440907130512y60a757afqd5629f4ca3ac8e1b@mail.gmail.com>
	 <4A5CD3E2.2060307@vlnb.net> <4A5D7794.2070607@vlnb.net>
Date: Thu, 16 Jul 2009 09:32:48 +0200
Message-ID: <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/15 Vladislav Bolkhovitin <vst@vlnb.net>:
>> The drop with 64 max_sectors_kb on the client is a consequence of how CFQ
>> is working. I can't find the exact code responsible for this, but from all
>> signs, CFQ stops delaying requests if amount of outstanding requests exceeds
>> some threshold, which is 2 or 3. With 64 max_sectors_kb and 5 SCST I/O
>> threads this threshold is exceeded, so CFQ doesn't recover order of
>> requests, hence the performance drop. With default 512 max_sectors_kb and
>> 128K RA the server sees at max 2 requests at time.
>>
>> Ronald, can you perform the same tests with 1 and 2 SCST I/O threads,
>> please?

Ok. Should I still use the file-on-xfs testcase for this, or should I
go back to using a regular block device? The file-over-iscsi is quite
uncommon I suppose, most people will export a block device over iscsi,
not a file.

> With context-RA patch, please, in those and future tests, since it should
> make RA for cooperative threads much better.
>
>> You can limit amount of SCST I/O threads by num_threads parameter of
>> scst_vdisk module.

Ok, I'll try that and include the blk_run_backing_dev,
readahead-context and io_context patches.

Ronald.
