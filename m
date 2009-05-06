Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZEFIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZEFIRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZEFIRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:17:08 -0400
Received: from [212.69.161.110] ([212.69.161.110]:56984 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZEFIRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:17:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Date: Wed, 6 May 2009 10:17:56 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-9-generic; KDE/4.2.0; i686; ; )
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <200905052345.20515.philipp.reisner@linbit.com> <1241560437.3312.159.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1241560437.3312.159.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905061017.56836.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>
> Well, you have to agree that during a resync from the activity log,
> which plays up the primary disk from one end to another, the secondary
> is completely corrupt if a primary failure occurs before the resync
> completes.  That's something that's triggered by a network outage, and
> so is a far more common event than cascading dual failures.  It's all
> really a question of where you focus your effort to eliminate the corner
> cases.
>

I fully agree. Just not not leave this unanswered: With DRBD we provide
a snapshot-resync-target handler. By using LVM's snapshotting
mechanism a snapshot is taken before it becomes resync-target. In
case the resync completes gracefully, the snapshot is automatically
removed.

Which is still inferior to a full transaction log on the secondary.

-Phil

