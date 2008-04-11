Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYDLHKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYDLHKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 03:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbYDLHKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 03:10:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:55327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYDLHKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=V/cYBwnzqBtkJHW2UVZFrO3KlFIko730tsNuffI6XtWn115uNwYVVXsnkLNWO2ZyrCwYPzWcpAFoQ/GFj3MaR2IOcH5w6qBacyafmh212DR0gDuxMfW/i42AW3g0uDk717N3sdnH0YInetfNs9C5sq9M28FDce1QGisaFF6FLo8=
Date: Sat, 12 Apr 2008 00:22:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] kernel: add common infrastructure for unaligned
	access
Message-ID: <20080411202238.GB9108@cvg>
References: <1207885137.22001.86.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207885137.22001.86.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Harvey Harrison - Thu, Apr 10, 2008 at 08:38:57PM -0700]
[...]
| +
| +static inline void __put_unaligned_be16(u16 val, u8 *p)
| +{
| +	*p++ = val >> 8;
| +	*p++ = val;
| +}
| +
[...]
| +static inline void __put_unaligned_le16(u16 val, u8 *p)
| +{
| +	*p++ = val;
| +	*p++ = val >> 8;
| +}
[...]

Hi Harvey, do we really need second increments? I mean, wouldn't
be better to use *p = val >> 8 and *p << 8?

		- Cyrill -
