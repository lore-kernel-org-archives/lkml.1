Return-Path: <linux-kernel-owner+w=401wt.eu-S376153AbXECPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376153AbXECPob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376154AbXECPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:44:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35362 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376153AbXECPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:44:30 -0400
Date: Thu, 3 May 2007 16:44:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org, Gerald Carter <coffeedude.jerry@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       linux-cifs-client@lists.samba.org, simo <idra@samba.org>
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a distinct module
Message-ID: <20070503154428.GA32713@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org,
	Gerald Carter <coffeedude.jerry@gmail.com>,
	linux-cifs-client@lists.samba.org, simo <idra@samba.org>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com> <20070501090657.GA17949@infradead.org> <1178198489.28758.14.camel@localhost.localdomain> <20070503141742.GB20328@infradead.org> <1178203013.28758.29.camel@localhost.localdomain> <4639F5AD.20807@gmail.com> <1178204186.28758.37.camel@localhost.localdomain> <524f69650705030835y488b0493wc97ab79ba25cd539@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650705030835y488b0493wc97ab79ba25cd539@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 10:35:41AM -0500, Steve French wrote:
> If SMB2 protocol support were coded as a distinct module, the smb2.ko
> would need to load cifs.ko to complete session setup in many cases
> (presumably when mounting to NetApp, EMC, most older Windows servers
> and some Samba servers - at least for a few years).

Umm, no.  If the user tries mount -t smb2 it would try only that and
if it can't support the server it would fail.  Similar for mount -t cifs
if the server only supports modern dialects, which AFAIK none does.
If you feel fancy add autoprobing to mount, similar to how we do
automatic testing of superblocks for disk filesystems.

> In any case SMB2 would be considered experimental (for a Linux client)
> for quite some time, so there is no hurry to decide until there is
> feedback from users.  I am pleased that SMB2 does clean up the
> protocol header format - and it should be easier to code in some ways
> since there are so few operations to support/optimize (and almost all
> are handlebased), but it is way to early to tell which is better (as
> far as I know, no one has even proved whether SMB2 is faster than CIFS
> or Vista to Vista mounts).

Beeing handle based means it actually starts to get useable for Unix
based client, so even if the protocol is not inherently faster the
client side implementation will be a lot faster at least on big
systems because the expensive path generation will go away.


