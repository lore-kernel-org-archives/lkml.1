Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZIVVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZIVVJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZIVVJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:09:20 -0400
Received: from mail.vyatta.com ([76.74.103.46]:49343 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZIVVJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:09:19 -0400
Date: Tue, 22 Sep 2009 14:09:14 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make refrigerator cold
Message-ID: <20090922140914.041b7328@s6510>
In-Reply-To: <200909222154.09726.rjw@sisk.pl>
References: <20090921210416.1982bcab@nehalam>
	<200909222154.09726.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 21:54:09 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 22 September 2009, Stephen Hemminger wrote:
> > By marking it cold, then the code path in kernel thread 
> > usage of try_to_freeze() that is normally used be
> > selected.
> 

In the code for try_to_freeze(), for optimization, it might
help to tell the compiler to not favor the code path where
the refigrator is being called.

Another way to do the same thing would be to do.
   if (unlikely(freezing(current))) {
	refrigerator();
	return 1;
   } else
	return 0;

or build unlikely into the freezing function (see need_resched).

I saw this by trying to minimize the number of intstructions
in pktgen which is a special case.



