Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXCZIe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXCZIe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXCZIe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:34:58 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:34070 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXCZIe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:34:57 -0400
Subject: Re: New format Intel microcode...
From: Marcel Holtmann <marcel@holtmann.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1174640590.1158.219.camel@laptopd505.fenrus.org>
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
	 <1174642985.23136.51.camel@aeonflux.holtmann.net>
	 <1174640590.1158.219.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 10:34:20 +0200
Message-Id: <1174898060.5815.11.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

> > > > Is the tool you mentioned last June [1] available for splitting up the
> > > > old firmware files to the new format (eg
> > > > /lib/firmware/intel-ucode/06-0d-06), or are updates available from
> > > > Intel (or otherwise) in this new format?
> > > Yes, we are preparing the new format data files and maybe put it into a
> > > new website. We will announce it when it's ready.
> > 
> > please do _NOT_ use any sub-directories in the request_firmware() call.
> 
> it's not a strictly a subdirectory; there is a slash in the "metaname"
> the kernel asks for, and you can in userspace see it as subdirectory or
> you don't.. that's entirely upto the userspace side :)

that is the whole point. The slash was never meant to be used. It was
designed to take a filename or a pattern that will be later matched by
userspace. However some developers are now trying to abuse this since
the simple firmware helper script matches this directly to a filename
(and directory in this case) on the disk.

Putting a slash in the request_firmware() call now enforces a
subdirectory and that should be left up to the userspace. So the slash
is actually a forbidden character here.

Regards

Marcel


