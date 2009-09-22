Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZIVXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZIVXM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZIVXM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:12:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZIVXM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:12:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] make refrigerator cold
Date: Wed, 23 Sep 2009 01:13:20 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20090921210416.1982bcab@nehalam> <200909222154.09726.rjw@sisk.pl> <20090922140914.041b7328@s6510>
In-Reply-To: <20090922140914.041b7328@s6510>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909230113.20461.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Stephen Hemminger wrote:
> On Tue, 22 Sep 2009 21:54:09 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday 22 September 2009, Stephen Hemminger wrote:
> > > By marking it cold, then the code path in kernel thread 
> > > usage of try_to_freeze() that is normally used be
> > > selected.
> > 
> 
> In the code for try_to_freeze(), for optimization, it might
> help to tell the compiler to not favor the code path where
> the refigrator is being called.
> 
> Another way to do the same thing would be to do.
>    if (unlikely(freezing(current))) {
> 	refrigerator();
> 	return 1;
>    } else
> 	return 0;
> 
> or build unlikely into the freezing function (see need_resched).
> 
> I saw this by trying to minimize the number of intstructions
> in pktgen which is a special case.

OK, thanks.

Will it be fine with you if I add the patch to the suspend-2.6 tree with the
above information in the changelog?

Rafael
