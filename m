Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbYETBCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbYETBCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYETBBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:01:51 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:37541 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbYETBBu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:01:50 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 21:01:49 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: 2.6.25.4-rt2
Date: Tue, 20 May 2008 08:44:42 +0800
Message-ID: <630E9048ECEBBB4798CE33255209FE730648317D@CNSHGSMBS02.ad4.ad.alcatel.com>
In-Reply-To: <Pine.LNX.4.58.0805191936120.4125@gandalf.stny.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25.4-rt2
Thread-Index: Aci6Ctuv65TtTiF6Q5KE5A+0F8fwCgAB6eXA
References: <1211237032.14697.76.camel@localhost.localdomain><1211239147.198
	45.42.camel@localhost> 
	<Pine.LNX.4.58.0805191936120.4125@gandalf.stny.rr.com>
From: "MA QING A" <Qing.a.Ma@alcatel-sbell.com.cn>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "RT" <linux-rt-users@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 20 May 2008 00:44:43.0838 (UTC) 
	FILETIME=[B1FCEDE0:01C8BA12]
X-imss-version: 2.050
X-imss-result: Passed
X-imss-approveListMatch: *@alcatel-sbell.com.cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgive me to ask a stupid question.
Why using the 24 mainline kernel, the time is less than using the rt-patched kernel?


-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Steven Rostedt
Sent: 2008Äê5ÔÂ20ÈÕ 7:44
To: Kasper Sandberg
Cc: LKML; RT; Ingo Molnar; Thomas Gleixner
Subject: Re: 2.6.25.4-rt2


On Tue, 20 May 2008, Kasper Sandberg wrote:

> On Mon, 2008-05-19 at 18:43 -0400, Steven Rostedt wrote:
> > We are pleased to announce the 2.6.25.4-rt2 tree, which can be

> Forgive me if i ask an obvious stupid question. But what is the status
> of this -rt tree for .25 in relation with the BKL stuff?

Well, the BKL is still a semaphore in 25.

For my hackbench runs, I have:

[root@bxrhel51 c]# cat hack-test-2.6.25.4-rt2
Time: 4.937
Time: 4.842
Time: 4.877
Time: 4.905
Time: 4.924
Time: 4.781
Time: 4.927
Time: 4.871
Time: 5.181
Time: 4.866

Which is a bit slower than 2.6.24.7-rt7:

[root@bxrhel51 c]# cat hack-test-2.6.24.7-rt7
Time: 4.789
Time: 4.824
Time: 4.807
Time: 4.867
Time: 4.802
Time: 4.799
Time: 4.823
Time: 4.855
Time: 4.873
Time: 4.833

But then I checked the base kernels themselves:

[root@bxrhel51 c]# cat hack-test-2.6.24.7
Time: 3.817
Time: 3.921
Time: 3.887
Time: 3.920
Time: 3.874
Time: 3.858
Time: 3.912
Time: 3.926
Time: 3.888
Time: 3.901

[root@bxrhel51 c]# cat hack-test-2.6.25.4
Time: 6.225
Time: 6.319
Time: 6.257
Time: 6.534
Time: 6.077
Time: 6.787
Time: 6.927
Time: 6.218
Time: 5.929
Time: 6.554


Where there's a regression somewhere. For 25, the RT patch is actually
*better* than mainline!

So I was thinking it had to do with the BKL regression, and then I ran:

[root@bxrhel51 c]# cat hack-test-2.6.26-rc3
Time: 6.789
Time: 7.123
Time: 6.197
Time: 5.496
Time: 6.708
Time: 5.609
Time: 6.679
Time: 6.206
Time: 6.351
Time: 5.969


Here it is no better, and the BKL has been converted into a spin lock.

But I'm very much busy working on -rt right now to dig deeper into this
regression.

-- Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
