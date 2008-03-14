Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYCNSOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYCNSOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYCNSOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:14:21 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60782 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYCNSOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:14:20 -0400
Date: Fri, 14 Mar 2008 14:14:13 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080314181413.GF2119@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313143631.GH27873@ics.muni.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 03:36:31PM +0100, Lukas Hejtmanek wrote:
> Hello,
> 
> On Wed, Mar 12, 2008 at 12:00:07PM -0400, J. Bruce Fields wrote:
> > In this case it looks like something in the gss context cache is bad.
> > 
> > I'm not sure what's going on.
> 
> I discovered what triggers this bug. If I have default export with secure
> option and I try to connect from insecure port, it produces the oops.
> If I add insecure option to the export, no oops at all and mount succeeds.
> 
> Also, the bug is not triggered by the first attempt but by the second one.
> 
> So I guess that from the first attempt there is something inserted into gss
> context cache - error occurs (insecure attempt with the secure option), gss
> context is removed from the cache as invalid but not completely. And the
> second attempt does oops. Sounds reasonable for me. 
> 
> Hope this helps to find the bug.

That's an excellent clue, thanks.  I wonder it would be explainable by a
reference count imbalance of some kind in fh_verify?  I don't quite see
it yet, and unfortunately can't yet reproduce the bug here.

--b.
