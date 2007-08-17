Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbXHQMEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbXHQMEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbXHQMEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:04:01 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60765 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXHQMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:04:00 -0400
Date: Fri, 17 Aug 2007 14:03:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH] Make checkpatch rant about trailing ; at the end of "if"
 expr
In-Reply-To: <46C41730.3060009@shadowen.org>
Message-ID: <Pine.LNX.4.64.0708171334460.30502@fbirervta.pbzchgretzou.qr>
References: <20070816052215.GA3857@kernel.sg> <46C41730.3060009@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16 2007 10:21, Andy Whitcroft wrote:
>> +		if ($line =~ /\bif\s*\([^\)]*\)\s*\;/) {
>
>Heh, you are the second person to suggest this check today, do I detect
>some ripped out hair due to one of these!
>
>I've taken this idea and expanded it to cover if, for and while which
>can all suffer from this.  Using the relative indent to work out which
>are valid combinations:

But. The above regex does not seem to handle

	if ((a = b));
		oops;

I have tried to come up with a superduper regex that handles multiple 
(), but my regex fu seems to stop above two pairs of ().

#!/usr/bin/perl

@check = (
	q"if ((ptr = malloc(bong, GFP)) == NULL)  ; (oopsie) ;",
	q"if ((ptr = malloc(bong, GFP)) == NULL)    (alright);",
	q"if (  ({ bool evil = (true); evil; }) ) ; (oopsie) ;",
	q"if (  ({ bool evil = (true); evil; }) )   (alright);",
	q"if((()));",
);

my $r = qr/\s*\(\s*(??{$r})?\s*\)\s*|\s*\(\s*[^()]+\s*\)\s*/;

foreach (@check) {
	if ($_ =~ /(if|for|while)$r;/) {
		print "ok $_\n";
	}
}


	Jan
-- 
