Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYL1VjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYL1VjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 16:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYL1Vi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 16:38:57 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58545 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbYL1Vi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 16:38:56 -0500
Date: Sun, 28 Dec 2008 21:38:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, resend] relatime: Let relatime update atime at least once per day
Message-ID: <20081228213852.GA20439@srcf.ucam.org>
References: <20081228152901.GB13565@srcf.ucam.org> <4957CDD2.9040903@tudelft.nl> <20081228195921.GB19176@srcf.ucam.org> <4957EEA7.3050101@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4957EEA7.3050101@tudelft.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 10:24:55PM +0100, Éric Piel wrote:

> Of course, by construction, there is nothing relying on the current
> relatime semantics. The problem is that whenever you are making relatime
> closer to the atime behaviour, you are also getting closer to the
> original drawbacks of atime (one read generates one write).

If your io is sufficiently limited that one write per file per day is a 
significant problem, then I think there's a more serious underlying 
problem.

> Actually, you are changing relatime from a boolean condition (maximum
> one additional write per write) to a atime with a coarse grain (maximum
> one additional write per day). Today you found a use case that needs a
> precision of one day. Tomorrow, someone else will find a use case that
> needs a precision of one hour. So maybe what is actually needed is a
> third option, a "grainatime" option where you can change the precision
> of the atime.

The answer to "The current two options are suboptimal in almost all 
cases" is very rarely "Add a new option". If boot is touching too many 
files, it should stop touching as many files. If you have crap disks, 
get better disks. If your life is spent tuning fs parameters for 1% 
performance gains, find a better job.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
