Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbZAGPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbZAGPpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZAGPpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:45:21 -0500
Received: from styx.suse.cz ([82.119.242.94]:34884 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751312AbZAGPpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:45:19 -0500
Date: Wed, 7 Jan 2009 16:45:17 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: Increase dirty_ratio and dirty_background_ratio?
Message-ID: <20090107154517.GA5565@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I'm writing mainly to gather opinions of clever people here ;). In commit
07db59bd6b0f279c31044cba6787344f63be87ea (in April 2007) Linus has
decreased default /proc/sys/vm/dirty_ratio from 40 to 10 and
/proc/sys/vm/dirty_background_ratio from 10 to 5. While tracking
performance regressions in SLES11 wrt SLES10 we noted that this has severely
affected perfomance of some workloads using Berkeley DB (basically because
what the database does is that it creates a file almost as big as available
memory, mmaps it and randomly scribbles all over it and with lower limits
it gets much earlier throttled / pdflush is more aggressive writing back
stuff which is counterproductive in this particular case).
  So the question is: What kind of workloads are lower limits supposed to
help? Desktop? Has anybody reported that they actually help? I'm asking
because we are probably going to increase limits to the old values for
SLES11 if we don't see serious negative impact on other workloads...
  Thanks for any ideas.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
