Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbXHBOIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbXHBOIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXHBOIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:08:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXHBOIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:08:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ehca: map 4k firmware context of cq, qp to user space
Date: Thu, 2 Aug 2007 16:08:15 +0200
User-Agent: KMail/1.9.6
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, raisch@de.ibm.com, paulus@samba.org
References: <200708021139.31695.hnguyen@linux.vnet.ibm.com>
In-Reply-To: <200708021139.31695.hnguyen@linux.vnet.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708021608.16436.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18bcyyOnP2eGpYyReIt1l3Ebn3Sf8gQEkrQY19
 7LD8aYj+CkumwZlGkGueCaAXZzUi/Zs07DMn9gAoyKTqzu9k0U
 aMJO7pVzi7ivShpncbeJw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007, Hoang-Nam Nguyen wrote:
> +#ifdef CONFIG_PPC_64K_PAGES
> +       /* make sure we map only 4k for fw context */
> +       ret = remap_4k_pfn(vma, vma->vm_start, physical >> EHCA_PAGESHIFT,
> +                          vma->vm_page_prot);
> +#else
>         ret = remap_pfn_range(vma, vma->vm_start, physical >> PAGE_SHIFT,
>                               vsize, vma->vm_page_prot);
> +#endif

remap_4k_pfn is defined in terms of remap_pfn_range if the base page
size if 4k, so you don't need this #ifdef afaics.

otherwise, the patch looks good.

	Arnd <><
