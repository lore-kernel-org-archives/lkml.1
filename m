Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbZA3BXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbZA3BXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZA3BXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:23:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:39641 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbZA3BXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:23:17 -0500
Date: Fri, 30 Jan 2009 02:23:15 +0100
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: npiggin@suse.de
Subject: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down
	Berkeley DB
Message-ID: <20090130012315.GB19554@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  today I found that commit 31a12666d8f0c22235297e1c1575f82061480029 (mm:
write_cache_pages cyclic fix) slows down operations over Berkeley DB.
Without this "fix", I can add 100k entries in about 5 minutes 30s, with
that change it takes about 20 minutes. 
  What is IMO happening is that previously we scanned to the end of file,
we left writeback_index at the end of file and went to write next file.
With the fix, we wrap around (seek) and after writing some more we go
to next file (seek again).
  Anyway, I think the original semantics of "cyclic" makes more sence, just
the name was chosen poorly. What we should do is really scan to the end of
file, reset index to start from the beginning next time and go for the next
file.
  I can write a patch to introduce this semantics but I'd like to hear
opinions of other people before I do so.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
