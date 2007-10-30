Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbXJ3UYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbXJ3UYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXJ3UY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:24:28 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:44690 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753973AbXJ3UY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:24:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DNLNMRzmI2i4wPF9B8cmKkUjwNAO6DWc5X262yaVeoKu5i7A6VvzC1DCXkj67Q5vUQaJuNaMtYHn86f11mmmMUnrz9toI0Me/PQm0rouVBkLhNrUfJiwjrrStSHKUFq8hDjtsFHkjTi1yhG1dVKfWPzikYXqsC+QyKoRFRudTh8=  ;
X-YMail-OSG: ZQ4iARgVM1kFSS1ktM.sYcTP7wo47ZnWFt2Z4Zo4De1FJhZBkRpjlze_9vQ2iyWOWbMKCTW5ZA--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 13/14] Blackfin SPI driver: Move cs_chg_udelay to cs_deactive to fix bug when some SPI LCD driver needs delay after cs_deactive
Date: Tue, 30 Oct 2007 13:18:59 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Cameron Barfield <cbarfield@cyberdata.net>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <1193735885-8202-14-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1193735885-8202-14-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710301319.00071.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007, Bryan Wu wrote:
> @@ -211,6 +211,10 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
>         flag |= (chip->flag << 8);
>  
>         write_FLAG(drv_data, flag);
> +
> +       /* Move delay here for consistency */
> +       if (chip->cs_chg_udelay)
> +               udelay(chip->cs_chg_udelay);
>  }
>  

By the way, if this is something needed very often, that mechanism
should be moved into the SPI framework.  It wouldn't be polite if
such LCD drivers could only work on Blackfin boards.  :)

