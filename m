Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZEDQNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZEDQNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZEDQNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:13:21 -0400
Received: from gate.in-addr.de ([212.8.193.158]:49517 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753171AbZEDQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:13:21 -0400
Date: Mon, 4 May 2009 18:12:52 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Lars Ellenberg <lars.ellenberg@linbit.com>, Neil Brown <neilb@suse.de>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090504161252.GN17956@suse.de>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <18941.12645.590037.589600@notabene.brown> <20090503082931.GD31340@racke> <18941.31069.695554.862567@notabene.brown> <20090503213231.GA6243@racke>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090503213231.GA6243@racke>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-05-03T23:32:31, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> Which it could not be while replication link is down,
> so once replication link is back (or remote node is back,
> which is not easily distinguishable just there, blablabla),
> you'd need to fetch the remote bitmap, and merge it with the local
> bitmap (feeding it into bitmap_set_bits),
> then re-attach the "failed" mirror.

Note that this sacrifices transactional consistency on the sync target;
an understandable trade-off (versus recording the stream of writes
entirely, which consumes space and possibly more resync bandwidth), but
a noteworthy one.

> But DRBD as of now does the connection handshake and bitmap exchange in
> kernel.  We wanted to have a fast compression scheme suitable for
> bitmaps, without cpu or memory overhead.  This does it quite nicely.

Sharing the connection between meta- and regular data also avoids some
ordering issues between channels, which probably helps simplify some
aspects of drbd.

Conceivably, the kernel could escalate such metadata/out-of-band
communications to user-space for handling, and user-space would then
afterwards instruct the continuation of the stream processing.

> or the link has been down,
> and the remote side decided to go active with it.

That is arguably a horrible failure on behalf of the cluster stack being
used, but indeed something drbd must be able to recover from.


Regards,
    Lars

-- 
SuSE Labs, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

