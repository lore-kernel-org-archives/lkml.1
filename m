Return-Path: <linux-kernel-owner+w=401wt.eu-S935141AbXJSRku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141AbXJSRku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXJSRkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:40:42 -0400
Received: from mail.softservecom.com ([195.160.232.17]:47515 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbXJSRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:40:41 -0400
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: w@1wt.eu, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071019095313.76990765.zaitcev@redhat.com>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
	 <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <20071014223921.GA4677@1wt.eu>
	 <1192542889.29039.66.camel@dell1.softservecom.com>
	 <20071016154138.GA23326@1wt.eu>
	 <1192559051.29039.139.camel@dell1.softservecom.com>
	 <1192644776.10761.60.camel@dell1.softservecom.com>
	 <35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com>
	 <20071019095313.76990765.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1192815634.7965.53.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Fri, 19 Oct 2007 20:40:35 +0300
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2007 17:40:34.0890 (UTC) FILETIME=[273EE2A0:01C81277]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Didn't here anything on this? What is our final decision here?
> 
> It's gotten worse, not better. Apparently, you aren't getting the
> concept of protecting the open count with a static lock and my
> explanations are just not vivid enough or something. So I decided
> to fix it myself. Maybe then the patch in C will explain it better
> than English. But I didn't have time to do it.

Probably I'm not trying to do what you want. I analyzed locks for other
usb drivers in 2.4 tree and used same ideas.
Static lock minor_table_mutex is used for minor table structure.
And dev->sem for dev manipulations and that's why for open_count.
If you will simply browse /drivers/usb dir for 2.4 you will see that
such approach is widely used there.
What's not right?
Certainly, you have more experience so I can't say that I'm right.

> Also, there's an outright bug in the latest version. Your purge
> of the wrong lock was incomplete and so there was an unbalanced up().
> But this is moot.

Yes, got it. It's up for minor_table_mutex in adu_release. Corrected.

> So, the version before the latest is borderline acceptable. If Willy
> wants to take it, it's fine. I'll fix it up later together with 2.6.

Let's do everything correctly for 2.4.

V.

