Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZHKXez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZHKXez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZHKXez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:34:55 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4820 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZHKXey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:34:54 -0400
Subject: Re: [PATCH] scripts: add typdef removal tool
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
In-Reply-To: <1250031061-16327-1-git-send-email-lrodriguez@atheros.com>
References: <1250031061-16327-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 16:34:15 -0700
Message-Id: <1250033655.8895.631.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 15:51 -0700, Luis R. Rodriguez wrote:
> If you are porting drivers and need to remove tydpefs you can use
> this to help you port the driver quicker.

> +	# This replaces the typdef declaration for a simple struct declaration - style 1
> +	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+_$from\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\1\};/g; print; }" $1
> +
> +	# This replaces the typdef declaration for a simple struct declaration - style 2
> +	perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+$to\s*\{([\d\D]+?)\}\s*$from\b[^;]*;/struct $to \{\1\};/g; print; }" $1
> +
> +	# This replaces the typdef usages with simple structs
> +	sed -r -i -e "s/\b$from\b/struct $to/g" $1
> +	sed -r -i -e "s/\bP$from\b/struct $to \*/g" $1
> +	sed -r -i -e "s/struct $to\s*\*\s*\b/struct $to \*/g" $1
> +	sed -r -i -e "s/\(struct $to\s*\*\)\s*/\(struct $to \*\)/g" $1

Hi Luis.

A couple of comments:

In the comments "typdef" should be "typedef".

I believe the sed statements need to be run before the perl statements.

Another common microsoft form is

	typedef struct tagFOO {
		members
	} FOO [, *PFOO [, **PPFOO ];

So maybe perl statement 1 could be:

s/\btypedef\s+struct\s+$to\s*(_{0,1}|tag)$from etc

and another sed statement might be:

sed -r -i -e "s/\(struct $to\s*\*\s*\*\s*\)\s*/\(struct $to \*\*\)/g" $1

Maybe you could test this against next:drivers/staging/hv/ to see
how well this works.

cheers, Joe

