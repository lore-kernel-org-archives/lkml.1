Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZESKrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZESKrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZESKrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:47:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:48493 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZESKrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:47:06 -0400
Subject: Re: [PATCH] LP3971 PMIC regulator driver (updated and combined
 version)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       kyungmin.park@samsung.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090519095847.GE27195@sirena.org.uk>
References: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
	 <20090515092030.GA2202@rakim.wolfsonmicro.main>
	 <1242641718.5473.2156.camel@vega.slimlogic.co.uk>
	 <000601c9d7ac$58af73d0$0a0e5b70$%szyprowski@samsung.com>
	 <1242647032.5473.2162.camel@vega.slimlogic.co.uk>
	 <002c01c9d843$69b09b40$3d11d1c0$%szyprowski@samsung.com>
	 <20090519095847.GE27195@sirena.org.uk>
Content-Type: text/plain
Date: Tue, 19 May 2009 11:47:01 +0100
Message-Id: <1242730021.5473.2550.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 10:58 +0100, Mark Brown wrote:
> On Tue, May 19, 2009 at 07:33:55AM +0200, Marek Szyprowski wrote:
> > This patch adds regulator drivers for National Semiconductors LP3971 PMIC.
> > This LP3971 PMIC controller has 3 DC/DC voltage converters and 5 low
> > drop-out
> > (LDO) regulators. LP3971 PMIC controller uses I2C interface.
> 
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> > +static int lp3971_dcdc_list_voltage(struct regulator_dev *dev, unsigned
> > index)
> 
> I'm OK with this but it looks like your MUA has mangled the patch by
> word wrapping so Liam may not be able to apply it.  There's some hints
> on configuring various mail clients in Documentation/email-clients.txt
> which might be helpful.
> 

I've now applied the patch after it was mangled by outlook.

I have also fixed the following build error :-

 CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
`lp3971_i2c_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o

with this :-

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 35abebe..a61018a 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -535,7 +535,7 @@ static struct i2c_driver lp3971_i2c_driver = {
                .owner = THIS_MODULE,
        },
        .probe    = lp3971_i2c_probe,
-       .remove   = lp3971_i2c_remove,
+       .remove   = __devexit_p(lp3971_i2c_remove),
        .id_table = lp3971_i2c_id,
 };

Best to pull for-next to get this fix.

Thanks

Liam

