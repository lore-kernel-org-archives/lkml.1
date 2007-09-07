Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXIGP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXIGP3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbXIGP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:29:16 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52163 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbXIGP3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:29:16 -0400
Date: Fri, 7 Sep 2007 11:29:13 -0400
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, nfs@lists.sourceforge.net,
       Trond Myklebust <trond@netapp.com>
Subject: Re: [BUG] 2.6.23-rc5 kernel BUG at fs/nfs/nfs4xdr.c:945
Message-ID: <20070907152913.GF24638@fieldses.org>
References: <46E121B8.4080105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E121B8.4080105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 03:32:32PM +0530, Kamalesh Babulal wrote:
> Sep  7 11:42:49 p55lp2 kernel: kernel BUG at fs/nfs/nfs4xdr.c:945!

That's the first line of encode_lookup:

	static int encode_lookup(struct xdr_stream *xdr, const struct qstr *name)
	{
		int len = name->len;
		__be32 *p;

		RESERVE_SPACE(8 + len);

So len is either very large, or it's just garbage.  Do you know if
fsstress is trying to do something with a particularly long filename
here?

--b.
