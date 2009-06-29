Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbZF2Ph6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbZF2Ph6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZF2Phs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:37:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZF2Phr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:37:47 -0400
Message-ID: <4A48DFBA.1070608@vlnb.net>
Date: Mon, 29 Jun 2009 19:37:30 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Ronald Moesbergen <intercommit@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net> <20090629093423.GB1315@localhost> <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com> <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net> <20090629131326.GA23668@localhost> <20090629132841.GA26171@localhost> <a0272b440906290743n5e089241x6e755115172a4a2a@mail.gmail.com> <20090629145147.GA29433@localhost>
In-Reply-To: <20090629145147.GA29433@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+7n3baWUljOPcNKlmBSAC7vyLVEym9/dtcKxD
 3Hol8xMhSHEh+mX8J1XBosacq3As00APP6vFheaZ2cEdIXhsK8
 uoDuS7kiNMl7eCKpJGXig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wu Fengguang, on 06/29/2009 06:51 PM wrote:
> On Mon, Jun 29, 2009 at 10:43:48PM +0800, Ronald Moesbergen wrote:
>> 2009/6/29 Wu Fengguang <fengguang.wu@intel.com>:
>>> On Mon, Jun 29, 2009 at 09:13:27PM +0800, Wu Fengguang wrote:
>>>> On Mon, Jun 29, 2009 at 09:04:57PM +0800, Vladislav Bolkhovitin wrote:
>>>>> Wu Fengguang, on 06/29/2009 04:54 PM wrote:
>>>>>> Why not 2.6.30? :)
>>>>> We started with 2.6.29, so why not complete with it (to save additional
>>>>> Ronald's effort to move on 2.6.30)?
>>>> OK, that's fair enough.
>>> btw, I backported the 2.6.31 context readahead patches to 2.6.29, just
>>> in case it will help the SCST performance.
>>>
>>> Ronald, if you run context readahead, please make sure that the server
>>> side readahead size is bigger than the client side readahead size.
>> I tried this patch on a vanilla kernel and no other patches applied,
>> but it does not seem to help. The iSCSI throughput does not go above
>> 60MB/s. (1GB in 17 seconds). I have tried several readahead settings
>> from 128KB up to 4MB and kept the server readahead at twice the client
>> readahead, but it never comes above 60MB/s. This is using SCST on the
> 
> OK, thanks for the tests anyway!
> 
>> serverside and openiscsi on the client. I get much better throughput
>> (90 MB/s) when using the patches supplied with SCST, together with the
> 
> What do you mean by "patches supplied with SCST"?

Ronald means io_context patch 
(http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/kernel/io_context-2.6.29.patch?revision=717), 
which allows SCST's I/O threads to share a single IO context.

Vlad

