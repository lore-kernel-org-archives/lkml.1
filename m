Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbYHOUSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbYHOUSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYHOURv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:17:51 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50510 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbYHOURu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:17:50 -0400
Date: Fri, 15 Aug 2008 16:17:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Valdis.Kletnieks@vt.edu
Cc: david@lang.hm, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] TALPA - a threat model? well sorta.
Message-ID: <20080815201742.GD22395@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	david@lang.hm, "Press, Jonathan" <Jonathan.Press@ca.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Helge Hafting <helge.hafting@aitel.hist.no>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk,
	alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
References: <1218723133.3540.137.camel@localhost.localdomain> <48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <alpine.DEB.1.10.0808150924260.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C0C@USILMS12.ca.com> <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C12@USILMS12.ca.com> <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm> <22811.1218823607@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22811.1218823607@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 02:06:47PM -0400, Valdis.Kletnieks@vt.edu wrote:
> This problem is actually identical to "new file scanned, but you don't have
> the signature available yet so malware isn't detected".
> 
> Those of us who have seen large mail servers pile up queues in the 10s of
> millions in the 45 minutes between when the worm went critical-mass and when
> we got a signature might disagree on it not being a big problem in practice.

For a mail server, I really think something specialized like ClamAV is
a much better solution than something in userspace, which will
probably decide it has to rescan every single file that gets written,
including your mail server logs.   :-)

A specialized solution for a mail server is *always* going to be able
to a more efficient, more practical, and be able to do
application-specialized things (such as refusing the e-mail while the
connection is still open, so you don't have to worry about being RFC
compliant about sending bounce mails when the SMTP return-path is most
likely bogus).

						- Ted
