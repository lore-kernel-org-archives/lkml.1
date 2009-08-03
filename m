Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZHCSEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZHCSEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZHCSEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:04:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZHCSEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:04:44 -0400
Date: Mon, 3 Aug 2009 14:04:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, alan@lxorguk.ukuu.org.uk, mmorley@hcl.in,
       pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090803180437.GA9798@infradead.org>
References: <1248466429.3567.82.camel@localhost> <20090803162303.GA31058@infradead.org> <1249318535.2447.26.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249318535.2447.26.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 12:55:35PM -0400, Eric Paris wrote:
> In linux-next you will find that those fields are completely unused and
> the kernel can be compiled without them with 0 lose of functionality
> (they are still used in linus's kernel by the audit system)
> 
> The only reason I didn't remove them entirely is because the inotify
> kernel interface is EXPORT_SYMBOL.  I plan to leave it around for a
> little bit until I'm sure out of tree users don't exist or at least had
> enough time to realize they need to use fsnotify.

There's absolutely no reason to keep them around, we never guaranteed
API stability and never cared about out of tree modules.  And if any
out of tree modules are out there using it they won't notice they need
to stop using it before you removed it.  So just nuke them entirely
in the for-2.6.32 queue.

