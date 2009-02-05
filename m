Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbZBEA2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbZBEA2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZBEA16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:27:58 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33574 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZBEA16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:27:58 -0500
Date: Wed, 4 Feb 2009 18:27:57 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
       Containers <containers@lists.osdl.org>, hch@lst.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [v2][PATCH 1/5] Unroll essentials of do_remount_sb() into
	devpts
Message-ID: <20090205002757.GA18758@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com> <20090204043640.GA26202@us.ibm.com> <20090204234905.GB17354@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204234905.GB17354@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> > 
> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> > Date: Tue, 27 Jan 2009 22:58:18 -0800
> > Subject: [v2][PATCH 1/5] Unroll essentials of do_remount_sb() into devpts
> > 
> > On remount, devpts fs only needs to parse the mount options. Users cannot
> > directly create/dirty files in /dev/pts so the MS_RDONLY flag and
> > shrinking the dcache does not really apply to devpts.
> > 
> > So effectively on remount, devpts only parses the mount options and updates
> > these options in its super block. As such, we could replace do_remount_sb()
> > call with a direct parse_mount_options().
> > 
> > Doing so enables subsequent patches to avoid parsing the mount options twice
> > and simplify the code.
> 
> You've dropped the update_ptmx_mode() which you used to do
> inside devpts_remount().  Is that also on purpose?

Since it appears that mknod_ptmx() will be called anyway and
will do the same thing,

> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>
