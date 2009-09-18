Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbZIROMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbZIROMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZIROMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:12:33 -0400
Received: from THUNK.ORG ([69.25.196.29]:52774 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZIROMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:12:32 -0400
Date: Fri, 18 Sep 2009 10:12:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is nobh code still useful?
Message-ID: <20090918141226.GB26991@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20090917135627.GB13660@duck.suse.cz> <4AB30AD1.7010400@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB30AD1.7010400@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 09:21:37PM -0700, Badari Pulavarty wrote:
>
> Originally it was supported on ext2. I added support nobh support for  
> ext3. At that time, the main
> issue/complaint was that, these bufferheads consume memory from  
> ZONE_NORMAL causing
> memory pressure on 32-bit (i386) configurations.

Specifically, it matters on very large configuration systems (i.e.,
32GB-64GB using PAE-36) that today we'd probably just say, "use
x86_64, you moron".  It would probably matter if someone were to want
to upgrade a non-64-bit capable machine to a newer kernel.  

Dropping nobh from ext3 at this point might prevent some of these
older systems from upgrading, I'm not sure how much we would care; on
the one hand, these machines tended to be pretty expensive, so people
would probably want to use them for a while.  On the other hand, it
has been over five years now since x86_64 machines have been
available, and many of these customers are highly unlikely to want to
upgrade anyway.

						- Ted


