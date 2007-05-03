Return-Path: <linux-kernel-owner+w=401wt.eu-S1161931AbXECNzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161931AbXECNzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161936AbXECNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:55:51 -0400
Received: from mail.samba.org ([66.70.73.150]:54688 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161931AbXECNzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:55:48 -0400
X-Greylist: delayed 2057 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 09:55:48 EDT
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a
	distinct module
From: simo <idra@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070501090657.GA17949@infradead.org>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
Content-Type: text/plain
Organization: Samba Team
Date: Thu, 03 May 2007 09:21:29 -0400
Message-Id: <1178198489.28758.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 10:06 +0100, Christoph Hellwig wrote:
> On Mon, Apr 30, 2007 at 05:52:43PM -0500, Steve French wrote:
> > Any idea which would be preferred (smb2 support as part of cifs, or as
> > a distinct smb2.ko module)?
> 
> Separate module please.  If we grow enough common code as some point
> we can move it into a smb_common.ko helper library, but given your
> above description I doubt that would useful.

Separate modules would mean the user have to know which protocol to
choose each time. And this make little sense.
You really want to auto-negotiate which protocol to use, because you
could have at the same time a connection to a Vista/Longhorn (SMB2)
machine and one to a Windows 2000 server (plain SMB) in the same domain
using the same credentials.

To me it make no sense to separate them out, unless one can load the
other on demand when needed and be able to pass all relevant data and
the network connection to the other.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer
email: idra@samba.org
http://samba.org

