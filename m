Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXF0U5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXF0U5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXF0U50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:57:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbXF0U5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:57:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/5 v2] Add the platform device support with RapidIO to MPC8641HPCN platform.
Date: Wed, 27 Jun 2007 22:56:15 +0200
User-Agent: KMail/1.9.6
Cc: Zhang Wei <wei.zhang@freescale.com>, mporter@kernel.crashing.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481375-git-send-email-wei.zhang@freescale.com> <1182933348216-git-send-email-wei.zhang@freescale.com>
In-Reply-To: <1182933348216-git-send-email-wei.zhang@freescale.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706272256.16418.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18JZYXMkcHAjh4AMcSx55qnc2GMjamfW8t1zb+
 WILyYOkVznmYbbR97GqXtgiZUnO9d80ibH7B2WX5yPHWKZid1q
 zncPBFmwzp1nuwsv8dUxw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007, Zhang Wei wrote:
> +static struct of_device_id mpc86xx_of_ids[] = {
> +       { .type = "soc", },
> +       { .compatible = "fsl,rapidio-delta", },
> +       {},
> +};
> +
> +static __init int mpc86xx_of_device_init(void)
> +{
> +       return of_platform_bus_probe(NULL, mpc86xx_of_ids, NULL);
> +}

This will add any devices below the "fsl,rapidio-delta" device
as an of_device. Is that what you actually want? I would guess that
you want to add the bridge itself, not the devices below it.

Is the rapidio device at the root of the device tree, and if so, why
not under the soc bus?

	Arnd <><
