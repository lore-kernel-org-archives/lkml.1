Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXAYT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXAYT2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030520AbXAYT2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:28:22 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:17315 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030519AbXAYT2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:28:22 -0500
Message-ID: <45B904CF.1070102@cfl.rr.com>
Date: Thu, 25 Jan 2007 14:28:15 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701242215.47777.vda.linux@googlemail.com> <45B8D041.8050507@cfl.rr.com> <200701251838.30796.vda.linux@googlemail.com>
In-Reply-To: <200701251838.30796.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2007 19:28:34.0975 (UTC) FILETIME=[016222F0:01C740B7]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14956.003
X-TM-AS-Result: No--5.769700-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> If you opened a file and are doing only O_DIRECT writes, you
> *always* have your written data flushed, by each write().
> How is it different from writes done using
> "normal" write() + fdatasync() pairs?

Because you can do writes async, but not fdatasync ( unless there is an 
async version I don't know about ).

> Ahhh shit, are you saying that fdatasync will wait until writes
> *by all other processes* to thios file will hit the disk?
> Is that thue?


I think all processes yes, but certainly all writes to this file by this 
process.  That means you have to sync for every write, which means you 
block.  Blocking stalls the pipeline.

