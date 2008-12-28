Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYL1T7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYL1T7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYL1T70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:59:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56729 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYL1T7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:59:25 -0500
Date: Sun, 28 Dec 2008 19:59:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least once per day
Message-ID: <20081228195921.GB19176@srcf.ucam.org>
References: <20081228152901.GB13565@srcf.ucam.org> <4957CDD2.9040903@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4957CDD2.9040903@tudelft.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 08:04:50PM +0100, Éric Piel wrote:
> Matthew Garrett schreef:
> > Ensure relatime updates atime at least once per day
> >     
> > Allow atime to be updated once per day even with relatime. This lets
> > utilities like tmpreaper (which delete files based on last access time)
> > continue working.
> :
> Sorry, but I doubt it's a good idea. First, it breaks the simple
> semantic of relatime (mtime > atime?), mixing it with a rather arbitrary
> constant. Second, and most important, there are lots of workloads which
> will be strongly affected by this modification. For instance, running
> md5sum daily on the filesystem will cause a write for every file.

Yes. And? I can't think of a single case where something could 
absolutely depend on the current relatime semantics, so altering them to 
more usefully match the atime semantics doesn't seem likely to cause any 
trouble.

> I think that to solve the problem for your use case, it's better to use
> a different approach such as mounting separately /tmp (with the atime
> option).

The use case in this case is the significant body of currently installed 
machines that don't have /tmp on a separate filesystem. In the very 
common setup of tmpreaper being used, the current relatime semantics 
will result in undesired data loss. I think the proposed alteration 
makes the behaviour of relatime massively more useful without any 
obvious drawbacks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
