Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXL1Cde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXL1Cde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 21:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXL1Cd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 21:33:26 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41601 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752473AbXL1CdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 21:33:25 -0500
Message-ID: <398809213.08803@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 28 Dec 2007 10:33:21 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: saeed bishara <saeed.bishara@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       NFS list <linux-nfs@vger.kernel.org>
Subject: Re: read-ahead in NFS server
References: <c70ff3ad0712260351i6583aa8dpbf16ed606a634b1f@mail.gmail.com> <47730F2F.3080900@garzik.org> <c70ff3ad0712270050u134616d1q459ed073c586dcec@mail.gmail.com> <47739288.7000308@garzik.org> <c70ff3ad0712270700h6336b194r7c21834423aeb331@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c70ff3ad0712270700h6336b194r7c21834423aeb331@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J852H-0002K7-P1@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 05:00:12PM +0200, saeed bishara wrote:
> > >> Are you using TCP?  Are you using NFSv4, or an older version?
> > > I'm using NFSv3/UDP.
> >
> > IMO, you definitely want TCP and NFSv4.  Much better network behavior,
> > with some of the silly UDP limits (plus greatly improved caching
> > behavior, due to v4 delegations).
> the clients of my system going to be embedded system with low
> performance cpus and I need UDP as it needs less cpu power.

You can try the attached adaptive readahead patch.
Apply it on your server and compile kernel with CONFIG_ADAPTIVE_READAHEAD.
Use large 1MB readahead on server and small readahead on clients.

> > > when I run local dd with bs=4K, I can see that the average IO size is
> > > more than 300KB.
> >
> > Read-ahead is easier in NFSv4, because the client probably has the file
> > delegated locally, and has far less need to constantly revalidate file
> > mapping(s).
> I'll check that.
> but what about the server side? why the issued IO's are only as twice
> as the size of the NFS requests?

The readahead code is helpless in NFSv3 :-(
Use NFS over TCP and rsize=readahead=1MB on client side could help.
But if you prefer UDP, the above patch may help you :-)

Fengguang

