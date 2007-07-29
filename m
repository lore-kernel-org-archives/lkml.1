Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbXG2Uja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbXG2Uja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbXG2UjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:39:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXG2UjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:39:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/5 v3] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Sun, 29 Jul 2007 15:56:35 +0200
User-Agent: KMail/1.9.6
Cc: Zhang Wei <wei.zhang@freescale.com>, galak@kernel.crashing.org,
       mporter@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393741899-git-send-email-wei.zhang@freescale.com> <11854393753986-git-send-email-wei.zhang@freescale.com>
In-Reply-To: <11854393753986-git-send-email-wei.zhang@freescale.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707291556.35632.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX187AAfNE3S+uTNMS8byK8aDFq8SCS71ysucGJ5
 /7lEXKulcoG6wlxMxhO18qDs+1KRVhBQGw2wlEnIaXajRlvf2n
 H5MJjgytTHX9M+W3nNX8A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007, Zhang Wei wrote:
> +
> +static struct of_device_id mpc86xx_of_ids[] = {
> +       { .type = "soc", },
> +       { .compatible = "fsl,rapidio-delta", },
> +       {},
> +};

With the device tree source you have posted in 2/5, the rapidio node is
a child of the soc bus, and it doesn't have any children of its own.
Therefore it is completely equivalent to _only_ add the soc type
to mpc86xx_of_ids[], as in 

static struct of_device_id mpc86xx_of_ids[] = {
       { .type = "soc", },
       {},
};

Even if you intend to add children to the rapidio node in the future,
I'd think it would be more appropriate to have those scanned by
the rapidio bus driver, not by of_platform.

	Arnd <><

