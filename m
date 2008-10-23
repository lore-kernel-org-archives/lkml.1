Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYJWGPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYJWGPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJWGP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:15:29 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:47291 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541AbYJWGP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:15:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i9UhnYLUuX6K9po/FaRJBX5GidAKoHWkuTa1G1foVB3emjj1MbPgLbk9B2JH8w3c3JZGXM/QpfnpeLdsQ/zLcZCFr7sNfCkVg+gCh8Gcdy7dLumw3T0IoT3eE/1ltuMGDvxGAOhUmuh2xfAsPsysxbGa5yFk4k/l1fkJg4y832M=  ;
X-YMail-OSG: lxysYlsVM1k4Q2WYYLoLcnYCKc76M_QuG4a6AqqTadH5IbCjD86Oy__YjbyH.3DvCh2CN1m2EfM4MCOcXm67.j1uPYyguqdgKjMvRqGsni_.4glxHVUaHpaEUqE7RC2dAa8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Wed, 22 Oct 2008 23:15:26 -0700
User-Agent: KMail/1.9.10
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081022104606.GA510@oksana.dev.rtsoft.ru> <20081022183218.GA19025@oksana.dev.rtsoft.ru>
In-Reply-To: <20081022183218.GA19025@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810222315.26576.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Anton Vorontsov wrote:
> --- a/drivers/gpio/pcf857x.c
> +++ b/drivers/gpio/pcf857x.c
> @@ -187,7 +187,7 @@ static int pcf857x_probe(struct i2c_client *client,
>         struct pcf857x                  *gpio;
>         int                             status;
>  
> -       pdata = client->dev.platform_data;
> +       pdata = pcf857x_get_pdata(client);
>         if (!pdata)
>                 return -ENODEV;
>  

I suppose that can work.  Regardless, some OF-specific code will
need to map device tree state into a generic format that's fully
decoupled from OF.  (And there's something to be said to having
that mapping sit in the same directory as the driver needing it.)


