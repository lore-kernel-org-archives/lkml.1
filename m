Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZDDRSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZDDRSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZDDRSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:18:24 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44780 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751453AbZDDRSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:18:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LcCbIvDFSy4Qj/P+nnJ8YuFJd3Xx63Wyq3rNrcmmOMck/F0DqHqiJnRZVd7Qq/9g+DLqu9zKEkbdi28XubuZH6hVwvtxDLl4FR2ypyDPzU3c4NL2PiTUyqAI7HsF9jLGPs3g1j6bi58nuluLsb+/cGDQ4qD46656tX+cxaC8ekc=  ;
X-YMail-OSG: 27gr8XMVM1krKU28a2mx177q3dnYsWp9.CEFbB8I._b5PNb97.b4av8aaqJGzzNb8Tiv.Uyu.eZNH8kmk491f1yRdilzfzlnF5deNvfr5nHZVwEBFZ0RDMhQuP_P_xntNwxcWVTAN3G_KLSvp3I0UzvWM06sa3rOkebJ0s5jjIQMvIIIalJHvqKGyyfxv.4sDhuZ2XBs85n.xbMVarCOHS7AEL5rxf3wj_BnkHx2VVyONN.53ANB1VeAdr99vUKYvKvFn2EtsiYJH9VXSUotoBkt7EcrIItMjPePOCWzOOnxrEtOK6XK
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kevin Cernekee <kpc.mtd@gmail.com>, dwmw2@infradead.org
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
Date: Sat, 4 Apr 2009 10:18:19 -0700
User-Agent: KMail/1.9.10
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org,
       Linux MTD <linux-mtd@lists.infradead.org>
References: <200903260042.42091.david-b@pacbell.net> <1238742215.20906.99.camel@localhost.localdomain> <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
In-Reply-To: <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904041018.19657.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Kevin Cernekee wrote:
> @@ -413,6 +590,12 @@ done:
> 
>  static int __init init_mtd(void)
>  {
> +       mtd_class = class_create(THIS_MODULE, "mtd");
> +
> +       if (IS_ERR(mtd_class)) {
> +               pr_err("Error creating mtd class.\n");
> +               return PTR_ERR(mtd_class);
> +       }

The reason I had the class creation code in its own initcall
is to ensure that it's there even when procfs isn't.  This
init_mtd() stuff is only there if procfs is configured.

So I don't much like this part of Kevin's change ... unless
MTD becomes dependent on procfs.  If there's an issue with
CONFIG_MTD=m then there's a better fix than this.


>         if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
>                 proc_mtd->read_proc = mtd_read_proc;
>         return 0;
> @@ -422,6 +605,7 @@ static void __exit cleanup_mtd(void)
>  {
>          if (proc_mtd)
>                 remove_proc_entry( "mtd", NULL);
> +       class_destroy(mtd_class);
>  }
> 
>  module_init(init_mtd);


