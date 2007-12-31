Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXLaTj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXLaTj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXLaTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:39:05 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:61095 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXLaTjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:39:03 -0500
Date: Mon, 31 Dec 2007 11:38:01 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to
	core
Message-ID: <20071231193801.GS13821@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071230190619.GA13757@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230190619.GA13757@joi>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 08:06:34PM +0100, Marcin Slusarz wrote:
> There are many places where these functions would be useful.
> (just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/)
> What do you think?
> 
> ps: this patch depends on http://lkml.org/lkml/2007/12/25/35
> --
> 
> add inline functions which add native byte order variable to
> little/big endian variable to core header and as an example
> convert ext3 to use them

You might want to note where you got these functions from in your message.

Also, it would be easier to follow these changes if you had broken things up
into two patches - one which moved stuff from ocfs2 into generic helpers and
a 2nd one to convert ext3.

Looking into my crystal ball, I see a bunch of "convert to using byteorder
math macros" patches coming down the pipe. Since we're talking about disk
fields where a mistake could be costly, I suggest that any patch more than a
couple of lines should be tested by the submitter with sparse. A statement
that sparse didn't produce any new warnings (with the patch applied) could
be included in the description.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
