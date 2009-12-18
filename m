Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZLRGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZLRGe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZLRGe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:34:57 -0500
Received: from 1wt.eu ([62.212.114.60]:52769 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZLRGe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:34:57 -0500
Date: Fri, 18 Dec 2009 07:34:54 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Is splice() useful without page stealing?
Message-ID: <20091218063454.GD32739@1wt.eu>
References: <23986fd90912171847w6d46ba2bx9d8763a63fc758c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23986fd90912171847w6d46ba2bx9d8763a63fc758c3@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 06:47:19PM -0800, Patrick J. LoPresti wrote:
(...)
> Now, if splice() actually let you do things like flip pages from the
> network stack into the page cache with zero copies, then I could see
> the point.  As it is, I am curious to know:
> 
> 1) Does anybody have any actual benchmarks showing performance
> advantages for splice() over read()/write()?   If so, can I obtain the
> benchmark code?

I did this for TCP->TCP sockets, and the gain is huge at high
bit rates (10 Gbps). Basically, 10 Gbps at 20% CPU with splice,
100% CPU with recv/send. You can find the test results here :

   http://haproxy.1wt.eu/10g.html

I'm not using splice for disk-to-net nor net-to-disk transfers though.

Willy

