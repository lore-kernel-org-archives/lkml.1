Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZFWTYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZFWTYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZFWTYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:24:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51033 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZFWTYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:24:31 -0400
Date: Tue, 23 Jun 2009 21:26:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623192650.GB23124@uranus.ravnborg.org>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com> <20090623090654.GC19062@uranus.ravnborg.org> <20090623235217.17fe844c@feng-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623235217.17fe844c@feng-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:52:17PM +0800, Feng Tang wrote:
> On Tue, 23 Jun 2009 17:06:54 +0800
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > +/*
> > > + * Table structures must be byte-packed to match the SFI
> > > specification,
> > > + * as they are provided by the BIOS.
> > > + */
> > > +#pragma pack(1)
> > > +struct sfi_table_header {
> > > +	char signature[SFI_SIGNATURE_SIZE];
> > > +	u32 length;
> > > +	u8 revision;
> > > +	u8 checksum;
> > > +	char oem_id[SFI_OEM_ID_SIZE];
> > > +	char oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> > > +};
> > Are they endian specific?
> > In that case use the correct endian specific types.
> 
> I can try to answer this question, Len, correct me if I'm wrong.
> 
> These SFI tables are just byte strings, and created by FW, FW can chose
> to use big-endian or little-endian in these tables based on what platform
> they are used. So it's transparent for SFI driver code.

But we have "u32 length;" - but I guess the signature
tell the endian then.

	Sam
