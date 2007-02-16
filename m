Return-Path: <linux-kernel-owner+w=401wt.eu-S1946009AbXBPQm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009AbXBPQm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946007AbXBPQm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:42:27 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:38950 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946005AbXBPQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:42:26 -0500
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ricknu-0@student.ltu.se, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20070212122738.b5e9a8af.akpm@linux-foundation.org>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
	 <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
	 <20070212122738.b5e9a8af.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 10:42:12 -0600
Message-Id: <1171644132.3443.27.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 12:27 -0800, Andrew Morton wrote:
> Given that we now have a standard kernel-wide, c99-friendly way of
> expressing true and false, I'd suggest that this decision can be revisited.
> 
> Because a "true" is significantly more meaningful (and hence readable)
> thing than a bare "1".

OK, I'm really not happy with doing this for three reasons:

1. It's inviting huge amounts of driver churn changing bitfields to
booleans

2. I do find it to be a readability issue.  Like most driver writers,
I'm used to register layouts, and those are simple bitfields, so I don't
tend to think true and false, I think 1 and 0.

3. Having a different, special, type for single bit bitfields (while
still using u<n> for multi bit bitfields) is asking for confusion, and
hence trouble at the driver level.

James


