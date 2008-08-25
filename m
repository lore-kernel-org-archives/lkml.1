Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYHYOlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYHYOlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYHYOlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:41:36 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43727 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242AbYHYOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:41:35 -0400
Date: Mon, 25 Aug 2008 10:41:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: ohyama_sec@ariel-networks.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question : ext2 compatibility feature mechanism
Message-ID: <20080825144132.GO1408@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	ohyama_sec@ariel-networks.com, linux-kernel@vger.kernel.org
References: <20080825120448.E013D378082@ns.ariel-networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825120448.E013D378082@ns.ariel-networks.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 09:04:48PM +0900, ohyama_sec@ariel-networks.com wrote:
> 
> Could you please give me the documents that is written about ext2
> filesystem at length, especially compatibility feature mechanism.

Please check out the Articles and Publiciations page on the ext4 wiki:

       http://ext4.wiki.kernel.org/index.php/Publications

The short version for how the compatibility feature mechanism works is
that there are three bitmasks, compat, rocompat, and incompat.  The
ext2/ext3/ext4 filesystem code in the kernel uses the these feature
bitmasks to test for the presence of features it understands, and will
read and write to the filesystem appropriately depending on which
features are enabled.

For bits in the feature bitmasks that the filesystem does not
recognize, bits in the "compat" bitmask are assumed to be changes that
are fully forwards compatible, so an implementation which sees a bit
in the "compat" bitmask which it doesn't understand should still feel
free to mount the filesystem and modify it as necessary.  If an
implementation sees a bit in the "rocompat" bitmask that it does not
understand, it is safe to mount the filesystem read/only, but
modifying the filesystem may likely damage the filesystem.  And if an
implementation sees a bit in the "incompat" bitmask that it does not
understand, it should reject mounting the filesystem entirely,
read/only or read/write.

E2fsck uses a much more stringent standard, in that if there are any
bits in the bitmask that it does not undersatnd, it will refuse to
touch the filesystem altogether, lest it damage the filesystem and
lose data as it tries to repair it.

Regards,

						- Ted
