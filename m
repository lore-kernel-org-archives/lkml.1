Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZEKKcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZEKKcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZEKKb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:31:58 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3041 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZEKKb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:31:57 -0400
Date: Mon, 11 May 2009 11:31:51 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: =?GB2312?B?0sHU8w==?= <wxc200@gmail.com>
cc: linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error 
 report
In-Reply-To: <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> 
 <20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk>
 <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="682240-1872984673-1242037911=:20970"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--682240-1872984673-1242037911=:20970
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 May 2009, =D2=C1=D4=F3 wrote:
> 2009/5/11 Michael Abbott <michael@araneidae.co.uk>
> > Now this is very odd. =A0I'd assumed the error messages I was getting w=
ere
> > just noise, but the commit you point me to uses KERN_ERR instead -- and=
 so
> > I get a brief storm of these messages on boot on my target:
> >
> > [ =A0 20.667923] i2c: error: exhausted retries
> > [ =A0 20.671962] i2c: msg_num: 0 msg_idx: -2000 msg_ptr: 0
> > [ =A0 20.677113] i2c: ICR: 000007e0 ISR: 00000002
> > [ =A0 20.677128] i2c: log: [00000446:000007e0]
> >
> > This is repeated nine times in total with exactly the same numbers. =A0=
Any
> > thoughts as to what this means? =A0Other than these messages on startup=
 my
> > I2C sensors seem to work perfectly well.
> If all error messages seem like "exhausted retries",not "timeout or
> master error",there maybe some operation conflicts,and i2c controller
> cannot succeed operateing after max times retry.  And which mode do
> your i2c work?  Poll or Interrupt?

Well, to be honest I don't actually know (I've inherited the driver and I=
=20
haven't figured out how the I2C drivers work), but here's how the i2c is=20
initialised:

static struct i2c_pxa_platform_data xcep_i2c_platform_data  =3D {
        .class =3D I2C_CLASS_HWMON
};

=2E..
        pxa_set_i2c_info(&xcep_i2c_platform_data);

This is called in the .init_machine method, and the target system is a=20
PXA255.

However, after the error messages on startup, all the sensors seem to be=20
detected and seem to be operating normally.
--682240-1872984673-1242037911=:20970--
