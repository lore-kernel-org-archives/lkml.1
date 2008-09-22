Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYIVQC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYIVQC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYIVQCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:02:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57859 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYIVQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:02:18 -0400
Subject: Re: [RFC v5][PATCH 9/9] Restore open file descriprtors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de
In-Reply-To: <48D04B19.9060502@cs.columbia.edu>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu>
	 <1221347167-9956-10-git-send-email-orenl@cs.columbia.edu>
	 <20080916230850.GB25445@us.ibm.com>  <48D04B19.9060502@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 09:02:09 -0700
Message-Id: <1222099329.8533.56.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 20:11 -0400, Oren Laadan wrote:
> 
> No. (this was discussed earlier already).
> 
> cr_hbuf_get() "allocates" space inside a dedicated buffer for headers
> in the checkpoint context (ctx->hbuf). It does not allocate new kernel
> memory. Instead, it returns the current position in that buffer
> ctx->hbuf[ctx->hpos], and advances ctx->hpos appropriately. On the
> other side, cr_hbuf_put() reverses that effect, reducing ctx->hpos
> accordingly.
> 
> If an error occurs, the checkpoint (or restart) operation is aborted,
> and eventually the context (ctx) will be cleaned up; at that point the
> special purpose buffer will be freed.

I think this is like claiming that my malloc() will get freed if my
applications exits, so I don't have to worry about free().  It is messy,
it makes lifetime rules and use less explicit, and it makes bugs harder
to find.  If I were a good programmer (which I'm not) I probably
wouldn't do that.

-- Dave

