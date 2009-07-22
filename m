Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZGVBPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZGVBPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZGVBPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:15:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39414 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZGVBPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:15:00 -0400
Subject: Re: [PATCH] cifs: fix sb->s_maxbytes so that it casts properly to
 a signed value
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <524f69650907211745t3c19724ete7f7a9c7b92fcfd2@mail.gmail.com>
References: <1248219723-832-1-git-send-email-jlayton@redhat.com>
	 <524f69650907211745t3c19724ete7f7a9c7b92fcfd2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 21:15:14 -0400
Message-Id: <1248225314.2516.22.camel@tupile.poochiereds.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 19:45 -0500, Steve French wrote:
> Fix seems logical, although would like to see the maxbytes field the
> correct size.  If it really is a loff_t rather than unsigned why
> wasn't sparse warning on the vfs in sendfile when it did this
> incorrect cast?
> 

*shrug* -- maybe sparse does throw a warning, I haven't checked. It's
also not necessarily an incorrect cast I guess -- depends on whether
it's just set too large.

I think we should consider changing s_maxbytes to loff_t, but I need to
have a closer look and make sure it wouldn't break anything. There are
also other fs's that probably need similar fixes.

> When did this start breaking, am a little surprised that connectathon
> (and the usual dbench, fsstress, fsx etc.) didn't break if sendfile
> was broken, and I don't think that cifs has changed in this area in a
> long time.
> 

This has been broken for a long, long time (at least a couple of years).
Most of the reports that I have are people complaining that web serving
using apache from CIFS shares doesn't work right. I think apache uses
multiple sendfile calls per file, and bails out when it gets an error on
the first call.

> Shouldn't this cc stable ... sendfile is important.
> 

No objection to -stable if everyone thinks it's important enough.

-- 
Jeff Layton <jlayton@redhat.com>

