Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZKPVPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZKPVPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZKPVO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:14:59 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:63706 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZKPVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:14:58 -0500
Message-ID: <4B01C03C.6000309@oracle.com>
Date: Mon, 16 Nov 2009 13:12:28 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       bcrl@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH]aio: remove unused field
References: <20091112075247.GA17960@sli10-desk.sh.intel.com> <20091113143408.c7965e74.akpm@linux-foundation.org>
In-Reply-To: <20091113143408.c7965e74.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B01C07E.014C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If we do this then kick_iocb() has only one in-kernel caller, in
> drivers/usb/gadget/inode.c.  I wonder if the gadget code really needs
> to be using kick_iocb()?

I don't think that it needs to, no.  It's only using the aio retry
functionality to perform a copy of read data into user space.

I have a patch to switch it to using schedule_work() instead:

  http://marc.info/?l=linux-fsdevel&m=125624446623075&w=2

I've been focusing on other things instead of pushing that to the usb
folks to be tested and merged, though.  I've cc:ed them in case they
want to run with this.

- z
