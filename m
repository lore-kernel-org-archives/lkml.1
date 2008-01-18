Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbYARTGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbYARTGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYARTGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:06:23 -0500
Received: from mail.impinj.com ([206.169.229.170]:49918 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752604AbYARTGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:06:22 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Subject: Re: Why is the kfree() argument const?
Date: Fri, 18 Jan 2008 11:06:08 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jakob Oestergaard <jakob@unthought.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com> <20080118094826.GN25527@unthought.net> <479091B5.4060700@cateee.net>
In-Reply-To: <479091B5.4060700@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181106.08511.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 18 Jan 2008 19:06:09.0642 (UTC) FILETIME=[2F631CA0:01C85A05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 03:47:01 am Giacomo A. Catenazzi wrote:
> Changing the name of variables in your example:
>
> extern print_int(const int *);
>
> int main(int argc, char **argv)
> {
>    extern int errno;
>
>    errno = 0;
>    print_int(&i);
>    return errno;
> }

Except that changing int to extern int makes all the difference in the world: 
the variable went from being local to being global. The way const is 
currently defined, however, the compiler cannot take advantage of the fact 
that the variable was local in the former case.

> Ok, I changed int to extern int, but you see the point?
> Do you want complex rules about const, depending on
> context (extern, volatile,...) ?

Sometimes complexity is worth it.

-- Vadim Lobanov
