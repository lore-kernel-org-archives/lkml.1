Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYF0Ogj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYF0Ogj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYF0Og2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:36:28 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36908 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbYF0Og1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:36:27 -0400
Subject: Re: [PATCH] keyspan: Remove duplicate device entries
From: Ben Collins <ben.collins@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080627034755.GA7763@suse.de>
References: <1214525296.7150.120.camel@cunning>
	 <20080627034755.GA7763@suse.de>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 27 Jun 2008 10:32:31 -0400
Message-Id: <1214577151.7150.384.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 20:47 -0700, Greg KH wrote:
> On Thu, Jun 26, 2008 at 08:08:16PM -0400, Ben Collins wrote:
> > The 28xb, as documented in comments, has the same ID's as the 28x.
> > Remove the duplicated ID's from the device tables, and expand the
> > comment to document this.
> 
> Was this causing a problem somehow?  How did you notice this?  Good
> catch.

Wasn't causing a problem, but I wrote a script awhile back that parses
modules.alias looking for exact matches (doesn't do any fnmatch stuff,
which might show more overlaps). Attached so you can see where this is
coming from.

Mainly I wrote it to make sure we didn't have any module overlap
(hostap/orinico kind of stuff), but it catches same module matching as
well.

> I'll add it to my queue, thanks,

Np

#!/usr/bin/perl -w

my %map;

if (!defined($ARGV[0])) {
	print STDERR "Usage: check-aliases <modules.alias>\n";
	exit(1);
}

$aliases = $ARGV[0];

open(ALIASES, "< $aliases") or die "Could not open $aliases";

while (<ALIASES>) {
	chomp;
	my ($junk, $alias, $module) = split;

	if (defined($map{$alias})) {
		printf("%s %20s / %-20s : %s \n", ("$map{$alias}" eq "$module")
			? "INT" : "   ", $map{$alias}, $module, $alias);
	} else {
		$map{$alias} = $module;
	}
}

exit(0);


