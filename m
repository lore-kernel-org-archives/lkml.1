Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbYLNAxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbYLNAxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLNAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:53:14 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:1768 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYLNAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:53:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J+Bt3zkHkOtsZDibu5VlhV5Dgv+RDG9tu8KehpuxHhR3GjJh5fZyn/r4JfvlUQoKal
         xjSodgc+8+syUiqb3eBQ3rmnntRIQJQYZT+zZYYb6rmTDAAPbZ5mWHGEjMRe+qGgaHPW
         Zh8kfrh0PYrQUaFItC+yzMkyKko7nEmv0tpRQ=
Subject: Re: [PATCH 3/4] ieee1394: mark bus_info_data was a __be32 array
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4944557A.7060902@s5r6.in-berlin.de>
References: <1229209354.11257.11.camel@brick>
	 <4944557A.7060902@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 16:53:11 -0800
Message-Id: <1229215991.11257.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-14 at 01:38 +0100, Stefan Richter wrote:
> Harvey Harrison wrote:
> > Two access functions get_max_rom and set_hw_config_rom are
> > changed to take __be32 as well.  Only bus_info_data was
> > ever passed in so this is OK.  All other uses of bus_info_data
> > treated it as a be32 value already.
> 
> I pushed the following out to linux1394-2.6.git:
> 
> Harvey Harrison (6):
>       ieee1394: pcilynx: trivial endian annotation
>       ieee1394: replace CSR_SET_BUS_INFO_GENERATION macro
>       ieee1394: mark bus_info_data as a __be32 array
>       ieee1394: eth1394: trivial sparse annotations
>       ieee1394: dv1394 annotate frame input/output structs as little endian
>       ieee1934: dv1394: interrupt enabling/disabling broken on big-endian
> 
> Note, I dropped two hunks from "mark bus_info_data..." due to another
> change which I posted only a few hours ago.  Please check:
> http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=d88b81b772c6db76eb3b9f9564034f55d0dcdd09
> This interfered with your patch:
> http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=6b09b72cbdcba8da71b85651eb37e0156aa65def
> 
> I pulled your patches into my master branch but not yet into my for-next
> branch (awaiting possible feedback on what I enqueued before your patches).

Looks OK to me, I needed to change the definition of get_max_rom to take
a be32 as it was only ever passed the bus_info_data, now that the other
patch removes that function entirely, the two hunks you dropped are no
longer needed.

Cheers,

Harvey

