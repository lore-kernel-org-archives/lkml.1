Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXBSLaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXBSLaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbXBSLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:30:22 -0500
Received: from smtp.nokia.com ([131.228.20.170]:52026 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbXBSLaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:30:21 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200702172205.11829.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <200702172205.11829.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 13:16:38 +0200
Message-Id: <1171883798.13817.13.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 11:16:38.0650 (UTC) FILETIME=[6C9C1DA0:01C75417]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219131301-32AA6BB0-39B9A3F7/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 22:05 +0100, Arnd Bergmann wrote:
> > +/* Maximum number of supported UBI devices */
> > +#define UBI_MAX_INSTANCES 32
> 
> Does this need to be limited?

It is how this is implemented at the moment. Note, this limits number of
UBI devices, not ubi _volumes_.

> > +/* UBI error messages */
> > +#define ubi_err(fmt, ...)                                                   \
> > +	printk(UBI_ERR_LEVEL UBI_ERR_PREF " %s " fmt "\n", __FUNCTION__,    \
> > +	       ##__VA_ARGS__)
> 
> You shouldn't need these helpers, just use the regular dev_dbg, dev_info
> and related macros.

I will look at them and see if they are ok.

> > +struct ubi_info {
> > +	int ubi_num;
> > +	struct ubi_io_info   *io;
> > +	struct ubi_bgt_info  *bgt;
> > +	struct ubi_wl_info   *wl;
> > +	struct ubi_beb_info  *beb;
> > +	struct ubi_vmt_info  *vmt;
> > +	struct ubi_ivol_info *ivol;
> > +	struct ubi_vtbl_info *vtbl;
> > +	struct ubi_acc_info  *acc;
> > +	struct ubi_upd_info  *upd;
> > +	struct ubi_eba_info  *eba;
> > +	struct ubi_uif_info  *uif;
> > +};
> 
> I don't know what went wrong here, but this does not at all
> look ok. The members in here probably should all be part
> of the ubi_info structure itself.

Will be fixed, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

