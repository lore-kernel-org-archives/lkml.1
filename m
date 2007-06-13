Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXFMQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXFMQUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbXFMQUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:20:36 -0400
Received: from mail.transmode.se ([83.241.175.147]:50039 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758074AbXFMQUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:20:35 -0400
X-Greylist: delayed 862 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 12:20:35 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Organization: Transmode AB
X-Mailer: Evolution 2.8.3 
In-Reply-To: <20070609162118.2680.99019.stgit@ACA800FC.ipt.aol.com>
content-class: urn:content-classes:message
Subject: Re: [PATCH] PHY fixed driver: rework release path and updatephy_id notation
Date: Wed, 13 Jun 2007 18:06:10 +0200
Message-ID: <1181750769.30670.304.camel@gentoo-jocke.transmode.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] PHY fixed driver: rework release path and updatephy_id notation
Thread-Index: Acet1MHjFur9/NHbSr+TfI/5EA1M1A==
References: <20070609162118.2680.99019.stgit@ACA800FC.ipt.aol.com>
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: "Vitaly Bordug" <vitb@kernel.crashing.org>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Reply-To: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 20:21 +0400, Vitaly Bordug wrote:
> device_bind_driver() error code returning has been fixed. 
> release() function has been written, so that to free resources
> in correct way; the release path is now clean.
> 
> Before the rework, it used to cause
>  Device 'fixed@100:1' does not have a release() function, it is broken
>  and must be fixed.
>  BUG: at drivers/base/core.c:104 device_release()
>  
>  Call Trace:  
>   [<ffffffff802ec380>] kobject_cleanup+0x53/0x7e
>   [<ffffffff802ec3ab>] kobject_release+0x0/0x9
>   [<ffffffff802ecf3f>] kref_put+0x74/0x81
>   [<ffffffff8035493b>] fixed_mdio_register_device+0x230/0x265
>   [<ffffffff80564d31>] fixed_init+0x1f/0x35
>   [<ffffffff802071a4>] init+0x147/0x2fb
>   [<ffffffff80223b6e>] schedule_tail+0x36/0x92
>   [<ffffffff8020a678>] child_rip+0xa/0x12
>   [<ffffffff80311714>] acpi_ds_init_one_object+0x0/0x83
>   [<ffffffff8020705d>] init+0x0/0x2fb
>   [<ffffffff8020a66e>] child_rip+0x0/0x12  
> 
> 
> Also changed the notation of the fixed phy definition on
> mdio bus to the form of <speed>+<duplex> to make it able to be used by
> gianfar and ucc_geth that define phy_id strictly as "%d:%d"
> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

Hi Vitaly

I am about to test this but I am having trouble figuring out how to
make ucc_geth find this PHY. Need some hints/template what to write
in the dts or board init code.

Also, I need several fixed PHYs, maybe you should export
fixed_mdio_register_device() ?

 Jocke


