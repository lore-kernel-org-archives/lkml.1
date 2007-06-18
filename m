Return-Path: <linux-kernel-owner+w=401wt.eu-S1763989AbXFRRIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763989AbXFRRIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbXFRRI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:08:28 -0400
Received: from gw.goop.org ([64.81.55.164]:37485 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbXFRRI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:08:27 -0400
Message-ID: <4676BBC9.3060707@goop.org>
Date: Mon, 18 Jun 2007 10:07:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Denis Cheng <crquan@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array	variable
 should be optimized out by data initialization
References: <467658db.0f98600a.5a55.ffffdd79@mx.google.com>
In-Reply-To: <467658db.0f98600a.5a55.ffffdd79@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Cheng wrote:
> From: Denis Cheng <crquan@gmail.com>
>
> the explicit memset call could be optimized out by data initialization,
> thus all the fill working can be done by the compiler implicitly.
>   

How does the generated code change?  Does gcc do something stupid like
statically allocate a prototype structure full of zeros, and then memcpy
it in?  Or does it generate a series of explicit assignments for each
member?  Or does it generate a memset anyway?

Seems to me that this gives gcc the opportunity to be more stupid, and
the only right answer is what we're doing anyway.

    J
