Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbXBQVG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbXBQVG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932907AbXBQVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:06:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:53703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580AbXBQVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:06:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Date: Sat, 17 Feb 2007 22:05:10 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702172205.11829.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18aSn2WHJIKEfAEuh4WHwNpomTkne2ZcNVVah97aqtDp8FQgWrEwssGPHk+JdaFe4JpEoy7Hjopi2Wantf0l1gDHsB9r3z+jOsFswMd9NZ5BQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 17:54, Artem Bityutskiy wrote:

> +/* Maximum number of supported UBI devices */
> +#define UBI_MAX_INSTANCES 32

Does this need to be limited?

> +/* UBI messages printk level */
> +#define UBI_MSG_LEVEL  KERN_INFO
> +#define UBI_WARN_LEVEL KERN_WARNING
> +#define UBI_ERR_LEVEL  KERN_ERR
> +
> +/* Prefixes of UBI messages */
> +#define UBI_MSG_PREF  "UBI:"
> +#define UBI_WARN_PREF "UBI warning:"
> +#define UBI_ERR_PREF  "UBI error:"
> +
> +/* Normal UBI messages */
> +#define ubi_msg(fmt, ...)                                                   \
> +	printk(UBI_MSG_LEVEL UBI_MSG_PREF " " fmt "\n", ##__VA_ARGS__)
> +/* UBI warning messages */
> +#define ubi_warn(fmt, ...)                                                  \
> +	printk(UBI_WARN_LEVEL UBI_WARN_PREF " %s: " fmt "\n", __FUNCTION__, \
> +	       ##__VA_ARGS__)
> +/* UBI error messages */
> +#define ubi_err(fmt, ...)                                                   \
> +	printk(UBI_ERR_LEVEL UBI_ERR_PREF " %s " fmt "\n", __FUNCTION__,    \
> +	       ##__VA_ARGS__)

You shouldn't need these helpers, just use the regular dev_dbg, dev_info
and related macros.

> +/**
> + * struct ubi_info - UBI device description structure
> + *
> + * @ubi_num: number of the UBI device
> + * @io: input/output unit information
> + * @bgt: background thread unit information
> + * @wl: wear-leveling unit information
> + * @beb: bad eraseblock handling unit information
> + * @vmt: volume management unit information
> + * @ivol: internal volume management unit information
> + * @vtbl: volume table unit information
> + * @acc: accounting unit information
> + * @upd: update unit information
> + * @eba: EBA unit information
> + * @uif: user interface unit information
> + */
> +struct ubi_info {
> +	int ubi_num;
> +	struct ubi_io_info   *io;
> +	struct ubi_bgt_info  *bgt;
> +	struct ubi_wl_info   *wl;
> +	struct ubi_beb_info  *beb;
> +	struct ubi_vmt_info  *vmt;
> +	struct ubi_ivol_info *ivol;
> +	struct ubi_vtbl_info *vtbl;
> +	struct ubi_acc_info  *acc;
> +	struct ubi_upd_info  *upd;
> +	struct ubi_eba_info  *eba;
> +	struct ubi_uif_info  *uif;
> +};

I don't know what went wrong here, but this does not at all
look ok. The members in here probably should all be part
of the ubi_info structure itself.

	Arnd <><
