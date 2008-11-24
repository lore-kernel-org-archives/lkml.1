Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYKXP4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYKXP4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbYKXP4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:56:35 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53434 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYKXP4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:56:34 -0500
Date: Mon, 24 Nov 2008 15:56:32 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: petkovbb@gmail.com
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Is the change to IDE probing really necessary?
Message-ID: <20081124155632.GE23190@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got caught by commit 20df429dd6671804999493baf2952f82582869fa as I didn't
immediately guess that "ide_generic." was necessary on the kernel command line
when compiled in instead of as a module. While it didn't catch me for long,
my concern is that this is going to trip up other people with old machines
that need that mask.  This change was introduced in 2.6.28-rc1 but I didn't
catch it till now as I hadn't used the laptop in a while.

I have a few questions on the commit.

1. Why was it necessary to disable the legacy probes like this at all?
Would it be possible to try the probe_mask in the event nothing is found
or does that have other consequences?

2. Related to one, how is a distro install using modules meant to be
fixed up? They would have to detect the probe failed, update their
modules configuration and try again. Rather than doing that, I would
imagine they add the probe_mask by default making this change somewhat
redundant.

3. It appears that the message will always appear whether the mask is
necessary or not. Why does it not get printed in the even nothing is found
at least to avoid noise? If the message is printed rarely, it should also
say what the kernel command line should be if ide_generic is compiled in.

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
