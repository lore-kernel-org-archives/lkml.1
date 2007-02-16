Return-Path: <linux-kernel-owner+w=401wt.eu-S1946206AbXBPSeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946206AbXBPSeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946207AbXBPSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:34:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57609 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946206AbXBPSe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:34:29 -0500
Date: Fri, 16 Feb 2007 10:34:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ricknu-0@student.ltu.se, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Message-Id: <20070216103422.51757e89.akpm@linux-foundation.org>
In-Reply-To: <1171644132.3443.27.camel@mulgrave.il.steeleye.com>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
	<1171132062.3373.31.camel@mulgrave.il.steeleye.com>
	<20070212122738.b5e9a8af.akpm@linux-foundation.org>
	<1171644132.3443.27.camel@mulgrave.il.steeleye.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 10:42:12 -0600 James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Mon, 2007-02-12 at 12:27 -0800, Andrew Morton wrote:
> > Given that we now have a standard kernel-wide, c99-friendly way of
> > expressing true and false, I'd suggest that this decision can be revisited.
> > 
> > Because a "true" is significantly more meaningful (and hence readable)
> > thing than a bare "1".
> 
> OK, I'm really not happy with doing this for three reasons:
> 
> 1. It's inviting huge amounts of driver churn changing bitfields to
> booleans
> 
> 2. I do find it to be a readability issue.  Like most driver writers,
> I'm used to register layouts, and those are simple bitfields, so I don't
> tend to think true and false, I think 1 and 0.
> 
> 3. Having a different, special, type for single bit bitfields (while
> still using u<n> for multi bit bitfields) is asking for confusion, and
> hence trouble at the driver level.
> 

Confused.  The patch changes TRUE to true and FALSE to false.  The code
wasn't using bitfields before and isn't using them afterwards.  I wouldn't
expect there to be any change in generated code.

All it's doing is replacing the driver's private TRUE/FALSE with the
kernel-wide ones.
