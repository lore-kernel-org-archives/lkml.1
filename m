Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZFWPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZFWPxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZFWPxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:53:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:3627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZFWPxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:53:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,276,1243839600"; 
   d="scan'208";a="468852099"
Date: Tue, 23 Jun 2009 23:52:17 +0800
From: Feng Tang <feng.tang@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623235217.17fe844c@feng-desktop>
In-Reply-To: <20090623090654.GC19062@uranus.ravnborg.org>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
	<b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
	<20090623090654.GC19062@uranus.ravnborg.org>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 17:06:54 +0800
Sam Ravnborg <sam@ravnborg.org> wrote:

> > +/*
> > + * Table structures must be byte-packed to match the SFI
> > specification,
> > + * as they are provided by the BIOS.
> > + */
> > +#pragma pack(1)
> > +struct sfi_table_header {
> > +	char signature[SFI_SIGNATURE_SIZE];
> > +	u32 length;
> > +	u8 revision;
> > +	u8 checksum;
> > +	char oem_id[SFI_OEM_ID_SIZE];
> > +	char oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> > +};
> Are they endian specific?
> In that case use the correct endian specific types.

I can try to answer this question, Len, correct me if I'm wrong.

These SFI tables are just byte strings, and created by FW, FW can chose
to use big-endian or little-endian in these tables based on what platform
they are used. So it's transparent for SFI driver code.

Thanks,
Feng

> 
> Same for the other types later in this file.
> 
> 	Sam
