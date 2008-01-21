Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYAUDEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYAUDEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 22:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbYAUDDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 22:03:36 -0500
Received: from ozlabs.org ([203.10.76.45]:37763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbYAUDDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 22:03:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: introduce blacklisting in modpost
Date: Mon, 21 Jan 2008 12:00:15 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
References: <20080120200527.GA23852@uranus.ravnborg.org> <1200859743-24037-3-git-send-email-sam@ravnborg.org> <1200859743-24037-4-git-send-email-sam@ravnborg.org>
In-Reply-To: <1200859743-24037-4-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211200.16104.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 07:08:59 Sam Ravnborg wrote:
> Change the logic in modpost so we identify all the
> bad combinations of sections that refer to other
> sections.
...
> +/* The pattern is an array of simple patterns.
> + * "foo" will match an exact string equal to "foo"
> + * "foo*" will match a string that begins with "foo"
> + * "foo$" will match a string equal to "foo" or "foo.1"
> + *   where the '1' can be any number including several digits.
> + *   The $ syntax is for sections where ld append a dot number
> + *   to make section name unique.

Dumb question: would it be easier to canonicalize all the section names by 
removing trailing .[num]*, then using fnmatch() and standard wildcards?

The rest of the patches look really nice: thanks for doing this cleanup!

Rusty.
